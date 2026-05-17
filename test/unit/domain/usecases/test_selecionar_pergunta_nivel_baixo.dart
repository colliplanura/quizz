import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';

@GenerateMocks([HistoricoPerguntaLocalDatasource])
import 'test_selecionar_pergunta_nivel_baixo.mocks.dart';

void main() {
  late MockHistoricoPerguntaLocalDatasource mockHistoricoDatasource;
  late SelecionarPergunta selecionarPergunta;

  setUp(() {
    mockHistoricoDatasource = MockHistoricoPerguntaLocalDatasource();
    selecionarPergunta = SelecionarPergunta(
      historicoDatasource: mockHistoricoDatasource,
      random: Random(42),
    );
  });

  group('SelecionarPergunta - Nível Baixo (1-3)', () {
    test('Distribuição de dificuldade em nível 1 predomínio de 1-3', () async {
      // Setup: 30 perguntas para cada dificuldade (1-10)
      final perguntas = <Pergunta>[];
      for (int dif = 1; dif <= 10; dif++) {
        for (int i = 0; i < 30; i++) {
          perguntas.add(
            Pergunta(
              id: 'pergunta-$dif-$i',
              pergunta: 'Pergunta $dif-$i',
              resposta: 'resposta',
              exibicaoResposta: 'Resposta',
              categoria: 'categoria',
              dificuldade: dif,
              contextoHistorico: {'pt_BR': 'Contexto'},
            ),
          );
        }
      }

      // Mock histórico vazio
      when(
        mockHistoricoDatasource.obterHistorico(),
      ).thenAnswer((_) async => {});
      when(
        mockHistoricoDatasource.marcarPerguntaRespondida(any, any),
      ).thenAnswer((_) async => {});

      // Execute: 100 sorteios em nível 1
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 1,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: ao menos 70% deve ser dificuldade 1-3
      final baixas = resultados.where((d) => d <= 3).length;
      final percentualBaixo = (baixas / resultados.length) * 100;

      expect(
        percentualBaixo,
        greaterThanOrEqualTo(70),
        reason:
            'Esperado 70% de dificuldade 1-3 em nível 1, obteve $percentualBaixo%',
      );
    });

    test('Distribuição de dificuldade em nível 2 predomínio de 1-3', () async {
      // Setup: perguntas com diferentes dificuldades
      final perguntas = <Pergunta>[];
      for (int dif = 1; dif <= 10; dif++) {
        for (int i = 0; i < 30; i++) {
          perguntas.add(
            Pergunta(
              id: 'pergunta-$dif-$i',
              pergunta: 'Pergunta $dif-$i',
              resposta: 'resposta',
              exibicaoResposta: 'Resposta',
              categoria: 'categoria',
              dificuldade: dif,
              contextoHistorico: {'pt_BR': 'Contexto'},
            ),
          );
        }
      }

      when(
        mockHistoricoDatasource.obterHistorico(),
      ).thenAnswer((_) async => {});
      when(
        mockHistoricoDatasource.marcarPerguntaRespondida(any, any),
      ).thenAnswer((_) async => {});

      // Execute: 100 sorteios em nível 2
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 2,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: ao menos 70% deve ser dificuldade 1-3
      final baixas = resultados.where((d) => d <= 3).length;
      final percentualBaixo = (baixas / resultados.length) * 100;

      expect(
        percentualBaixo,
        greaterThanOrEqualTo(70),
        reason:
            'Esperado 70% de dificuldade 1-3 em nível 2, obteve $percentualBaixo%',
      );
    });

    test('Distribuição de dificuldade em nível 3 predomínio de 1-3', () async {
      // Setup: perguntas com diferentes dificuldades
      final perguntas = <Pergunta>[];
      for (int dif = 1; dif <= 10; dif++) {
        for (int i = 0; i < 30; i++) {
          perguntas.add(
            Pergunta(
              id: 'pergunta-$dif-$i',
              pergunta: 'Pergunta $dif-$i',
              resposta: 'resposta',
              exibicaoResposta: 'Resposta',
              categoria: 'categoria',
              dificuldade: dif,
              contextoHistorico: {'pt_BR': 'Contexto'},
            ),
          );
        }
      }

      when(
        mockHistoricoDatasource.obterHistorico(),
      ).thenAnswer((_) async => {});
      when(
        mockHistoricoDatasource.marcarPerguntaRespondida(any, any),
      ).thenAnswer((_) async => {});

      // Execute: 100 sorteios em nível 3
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 3,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: ao menos 70% deve ser dificuldade 1-3
      final baixas = resultados.where((d) => d <= 3).length;
      final percentualBaixo = (baixas / resultados.length) * 100;

      expect(
        percentualBaixo,
        greaterThanOrEqualTo(70),
        reason:
            'Esperado 70% de dificuldade 1-3 em nível 3, obteve $percentualBaixo%',
      );
    });

    test('Distribuição possui aleatoriedade dentro da faixa alvo', () async {
      // Setup: 50 perguntas com dificuldade 1-3
      final perguntas = <Pergunta>[];
      for (int dif = 1; dif <= 3; dif++) {
        for (int i = 0; i < 50; i++) {
          perguntas.add(
            Pergunta(
              id: 'pergunta-$dif-$i',
              pergunta: 'Pergunta $dif-$i',
              resposta: 'resposta',
              exibicaoResposta: 'Resposta',
              categoria: 'categoria',
              dificuldade: dif,
              contextoHistorico: {'pt_BR': 'Contexto'},
            ),
          );
        }
      }

      when(
        mockHistoricoDatasource.obterHistorico(),
      ).thenAnswer((_) async => {});
      when(
        mockHistoricoDatasource.marcarPerguntaRespondida(any, any),
      ).thenAnswer((_) async => {});

      // Execute: 100 sorteios
      final idsUnicas = <String>{};
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 2,
        );
        idsUnicas.add(pergunta.id);
      }

      // Verify: deve ter pelo menos 20 IDs únicos em 100 sorteios
      expect(
        idsUnicas.length,
        greaterThanOrEqualTo(20),
        reason:
            'Esperado aleatoriedade (>20 IDs únicos em 100 sorteios), obteve ${idsUnicas.length}',
      );
    });
  });
}
