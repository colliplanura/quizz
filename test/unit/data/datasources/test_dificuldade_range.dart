import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dificuldade Range Validation', () {
    test('todas as perguntas devem ter dificuldade entre 1 e 10', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final invalidDificuldades = <int>[];
      final dificuldadeDistribution = <int, int>{};

      for (var item in jsonData) {
        final dificuldade = item['dificuldade'];

        expect(
          dificuldade,
          isNotNull,
          reason: 'Pergunta ${item['id']} deve ter dificuldade',
        );
        expect(dificuldade, isA<int>(), reason: 'Dificuldade deve ser inteiro');

        final diff = dificuldade as int;

        if (diff < 1 || diff > 10) {
          invalidDificuldades.add(diff);
        }

        dificuldadeDistribution[diff] =
            (dificuldadeDistribution[diff] ?? 0) + 1;
      }

      expect(
        invalidDificuldades,
        isEmpty,
        reason:
            'Dificuldade deve estar entre 1 e 10. Encontrados: ${invalidDificuldades.toSet()}',
      );
    });

    test(
      'distribuição de dificuldade deve cobrir todos os 10 níveis',
      () async {
        final jsonString = await _loadAsset(
          'assets/data/perguntas_inicial.json',
        );
        final jsonData = _parseJsonArray(jsonString);

        final dificuldadesEncontradas = <int>{};

        for (var item in jsonData) {
          final dificuldade = item['dificuldade'] as int;
          dificuldadesEncontradas.add(dificuldade);
        }

        for (int i = 1; i <= 10; i++) {
          expect(
            dificuldadesEncontradas.contains(i),
            isTrue,
            reason: 'Deve haver perguntas com dificuldade $i',
          );
        }
      },
    );

    test(
      'cada nível de dificuldade deve ter pelo menos algumas perguntas',
      () async {
        final jsonString = await _loadAsset(
          'assets/data/perguntas_inicial.json',
        );
        final jsonData = _parseJsonArray(jsonString);

        final dificuldadeDistribution = <int, int>{};

        for (var item in jsonData) {
          final dificuldade = item['dificuldade'] as int;
          dificuldadeDistribution[dificuldade] =
              (dificuldadeDistribution[dificuldade] ?? 0) + 1;
        }

        // Print distribution for validation
        print('Distribuição de dificuldade:');
        for (int i = 1; i <= 10; i++) {
          final count = dificuldadeDistribution[i] ?? 0;
          print('  Nível $i: $count perguntas');
          expect(
            count,
            greaterThan(0),
            reason: 'Nível $i deve ter pelo menos uma pergunta',
          );
        }
      },
    );

    test('soma de todas as dificuldades deve ser 1000', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final dificuldadeDistribution = <int, int>{};

      for (var item in jsonData) {
        final dificuldade = item['dificuldade'] as int;
        dificuldadeDistribution[dificuldade] =
            (dificuldadeDistribution[dificuldade] ?? 0) + 1;
      }

      var total = 0;
      for (var count in dificuldadeDistribution.values) {
        total += count;
      }

      expect(total, equals(1000), reason: 'Total de perguntas deve ser 1000');
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
