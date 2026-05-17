import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Catalog Load Performance', () {
    test('carregamento do catálogo deve ser menor que 200ms no p95', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final durations = <Duration>[];

      // Execute 30 times to get statistical measurement
      for (int i = 0; i < 30; i++) {
        final stopwatch = Stopwatch()..start();

        // Simulate catalog load
        final jsonData = _parseJsonArray(jsonString);
        expect(jsonData.length, equals(1000));

        stopwatch.stop();
        durations.add(stopwatch.elapsed);
      }

      // Sort durations to find p95
      durations.sort();
      final p95Index = (durations.length * 0.95).floor();
      final p95Duration = durations[p95Index];

      print('Performance metrics:');
      print('  Min: ${durations.first.inMilliseconds}ms');
      print('  Max: ${durations.last.inMilliseconds}ms');
      print('  p95: ${p95Duration.inMilliseconds}ms');
      print(
        '  Mean: ${durations.fold<int>(0, (a, b) => a + b.inMilliseconds) ~/ durations.length}ms',
      );

      expect(
        p95Duration.inMilliseconds,
        lessThan(200),
        reason:
            'p95 latency deve ser menor que 200ms, obteve ${p95Duration.inMilliseconds}ms',
      );
    });

    test('parsing de JSON deve ser eficiente', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');

      final stopwatch = Stopwatch()..start();
      final jsonData = _parseJsonArray(jsonString);
      stopwatch.stop();

      print(
        'JSON parsing took ${stopwatch.elapsedMilliseconds}ms para ${jsonData.length} items',
      );

      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(500),
        reason: 'Parsing deve ser rápido',
      );
    });

    test('acesso aleatório aos dados deve ser rápido', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final stopwatch = Stopwatch()..start();

      // Access 100 random items
      for (int i = 0; i < 100; i++) {
        final randomIndex = (i * 7) % jsonData.length; // pseudo-random
        final item = jsonData[randomIndex];
        expect(item['id'], isNotNull);
      }

      stopwatch.stop();

      print(
        'Random access to 100 items took ${stopwatch.elapsedMilliseconds}ms',
      );
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(50),
        reason: 'Acesso aleatório deve ser muito rápido',
      );
    });
  });
}

// Helper functions
Future<String> _loadAsset(String path) async {
  return File(path).readAsString();
}

List<Map<String, dynamic>> _parseJsonArray(String jsonString) {
  final parsed = json.decode(jsonString);
  if (parsed is! List) {
    throw const FormatException('JSON root must be an array');
  }
  return parsed
      .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}
