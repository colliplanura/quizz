import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/models/pergunta_model.dart';

void main() {
  group('Contrato GitHub: schema de perguntas com contexto_historico', () {
    const payloadValido = '''
    [
      {
        "id": "q-001",
        "pergunta": "Qual é a capital do Brasil?",
        "resposta": "brasilia",
        "exibicao_resposta": "Brasília",
        "categoria": "geografia",
        "dificuldade": 1,
        "contexto_historico": {
          "pt_BR": "Brasília foi inaugurada em 1960.",
          "en": "Brasília was inaugurated in 1960.",
          "it": "Brasília fu inaugurata nel 1960."
        }
      }
    ]
    ''';

    test('deserializa payload válido com contexto_historico multilingual', () {
      final lista = (jsonDecode(payloadValido) as List)
          .cast<Map<String, dynamic>>()
          .map(PerguntaModel.fromJson)
          .toList();

      expect(lista.length, equals(1));
      final pergunta = lista.first;
      expect(pergunta.id, equals('q-001'));
      expect(pergunta.resposta, equals('brasilia'));
      expect(pergunta.contextoHistorico['pt_BR'], contains('1960'));
      expect(pergunta.contextoHistorico['en'], contains('1960'));
      expect(pergunta.contextoHistorico['it'], contains('1960'));
    });

    test('fallback para pt_BR quando idioma ausente', () {
      final json = {
        'id': 'q-002',
        'pergunta': 'Pergunta teste',
        'resposta': 'teste',
        'exibicao_resposta': 'Teste',
        'categoria': 'geral',
        'dificuldade': 1,
        'contexto_historico': {'pt_BR': 'Contexto PT'},
      };
      final p = PerguntaModel.fromJson(json);
      expect(p.contextoParaIdioma('en'), equals('Contexto PT'));
      expect(p.contextoParaIdioma('it'), equals('Contexto PT'));
    });

    test('rejeita pergunta sem campos obrigatórios graciosamente', () {
      final jsonInvalido = <String, dynamic>{
        'id': 'q-003',
        // falta pergunta, resposta etc.
      };
      expect(() => PerguntaModel.fromJson(jsonInvalido), throwsA(anything));
    });

    test('payload vazio resulta em lista vazia', () {
      final lista = (jsonDecode('[]') as List)
          .cast<Map<String, dynamic>>()
          .map(PerguntaModel.fromJson)
          .toList();
      expect(lista, isEmpty);
    });
  });
}
