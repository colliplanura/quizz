import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PerguntaID Uniqueness', () {
    test('todos os IDs do catálogo devem ser únicos', () async {
      // Load catalog from JSON asset
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final ids = <String>{};
      final duplicatas = <String>[];

      for (var item in jsonData) {
        final id = item['id'] as String;

        // Validate ID format: should be non-empty string
        expect(id, isNotEmpty, reason: 'ID não pode estar vazio');

        if (ids.contains(id)) {
          duplicatas.add(id);
        }
        ids.add(id);
      }

      expect(
        duplicatas,
        isEmpty,
        reason:
            'Deve haver 1000 IDs únicos. Encontrados ${duplicatas.length} duplicados: ${duplicatas.take(10)}',
      );
    });

    test('cada ID deve ser uma string não vazia', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      for (var i = 0; i < jsonData.length; i++) {
        final item = jsonData[i];
        final id = item['id'];

        expect(id, isNotNull, reason: 'Pergunta índice $i deve ter ID');
        expect(id, isA<String>(), reason: 'ID deve ser string');
        expect(
          (id as String).isNotEmpty,
          isTrue,
          reason: 'ID não pode estar vazio',
        );
      }
    });

    test('IDs devem seguir formato consistente', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      for (var item in jsonData) {
        final id = item['id'] as String;

        // Basic format validation: alphanumeric and hyphens allowed
        expect(
          id,
          matches(RegExp(r'^[a-zA-Z0-9_-]+$')),
          reason:
              'ID "$id" deve conter apenas caracteres alpanuméricos, hífens e underscores',
        );
      }
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
