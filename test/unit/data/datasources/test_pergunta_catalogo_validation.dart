import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/models/pergunta_model.dart';

void main() {
  group('PerguntaCatalogo Validation', () {
    test('catalogo deve conter exatamente 1000 perguntas', () async {
      // Load catalog from JSON asset
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      expect(jsonData, isNotEmpty);
      expect(
        jsonData.length,
        equals(1000),
        reason: 'Catálogo deve conter exatamente 1000 perguntas válidas',
      );
    });

    test('catalogo deve conter no mínimo 10 categorias', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final categorias = <String>{};
      for (var item in jsonData) {
        categorias.add(item['categoria'] as String);
      }

      expect(
        categorias.length,
        greaterThanOrEqualTo(10),
        reason: 'Deve haver no mínimo 10 categorias diferentes',
      );
    });

    test('cada categoria deve ter no mínimo 50 perguntas', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final categoriaContagem = <String, int>{};
      for (var item in jsonData) {
        final categoria = item['categoria'] as String;
        categoriaContagem[categoria] = (categoriaContagem[categoria] ?? 0) + 1;
      }

      for (var entry in categoriaContagem.entries) {
        expect(
          entry.value,
          greaterThanOrEqualTo(50),
          reason:
              'Categoria "${entry.key}" deve ter no mínimo 50 perguntas, mas tem ${entry.value}',
        );
      }
    });

    test('todas as perguntas devem ter estrutura válida', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      for (var item in jsonData) {
        // Try to create a PerguntaModel to validate structure
        expect(
          () {
            PerguntaModel.fromJson(item);
          },
          returnsNormally,
          reason: 'Pergunta com ID ${item['id']} deve ter estrutura válida',
        );
      }
    });

    test('nenhuma pergunta deve estar duplicada por ID', () async {
      final jsonString = await _loadAsset('assets/data/perguntas_inicial.json');
      final jsonData = _parseJsonArray(jsonString);

      final ids = <String>{};
      final duplicatas = <String>[];

      for (var item in jsonData) {
        final id = item['id'] as String;
        if (ids.contains(id)) {
          duplicatas.add(id);
        }
        ids.add(id);
      }

      expect(
        duplicatas,
        isEmpty,
        reason:
            'Não deve haver perguntas duplicadas. IDs duplicados: $duplicatas',
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
