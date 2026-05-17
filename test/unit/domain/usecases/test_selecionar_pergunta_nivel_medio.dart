import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';

@GenerateMocks([HistoricoPerguntaLocalDatasource])
import 'test_selecionar_pergunta_nivel_medio.mocks.dart';

void main() {
  late MockHistoricoPerguntaLocalDatasource mockHistoricoDatasource;
  late SelecionarPergunta selecionarPergunta;

  setUp(() {
    mockHistoricoDatasource = MockHistoricoPerguntaLocalDatasource();
    selecionarPergunta = SelecionarPergunta(
      historicoDatasource: mockHistoricoDatasource,
      random: Random(123),
    );
  });

  group('SelecionarPergunta - Nível Médio (4-7)', () {
    test(
      'Distribuição de dificuldade em nível 4 com aderência ao nível',
      () async {
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

        when(
          mockHistoricoDatasource.obterHistorico(),
        ).thenAnswer((_) async => {});
        when(
          mockHistoricoDatasource.marcarPerguntaRespondida(any, any),
        ).thenAnswer((_) async => {});

        // Execute: 100 sorteios em nível 4
        final resultados = <int>[];
        for (int i = 0; i < 100; i++) {
          final pergunta = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: 4,
          );
          resultados.add(pergunta.dificuldade);
        }

        // Verify: dificuldade 4 e próximas (3-5) devem ser predominantes
        final proximasAlvo = resultados.where((d) => d >= 3 && d <= 5).length;
        final percentualProximasAlvo = (proximasAlvo / resultados.length) * 100;

        expect(
          percentualProximasAlvo,
          greaterThanOrEqualTo(50),
          reason:
              'Esperado 50% de dificuldade 3-5 em nível 4, obteve $percentualProximasAlvo%',
        );
      },
    );

    test(
      'Distribuição de dificuldade em nível 5 com aderência ao nível',
      () async {
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

        // Execute: 100 sorteios em nível 5
        final resultados = <int>[];
        for (int i = 0; i < 100; i++) {
          final pergunta = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: 5,
          );
          resultados.add(pergunta.dificuldade);
        }

        // Verify: dificuldade 5 e próximas (4-6) devem ser predominantes
        final proximasAlvo = resultados.where((d) => d >= 4 && d <= 6).length;
        final percentualProximasAlvo = (proximasAlvo / resultados.length) * 100;

        expect(
          percentualProximasAlvo,
          greaterThanOrEqualTo(50),
          reason:
              'Esperado 50% de dificuldade 4-6 em nível 5, obteve $percentualProximasAlvo%',
        );
      },
    );

    test(
      'Distribuição de dificuldade em nível 6 com aderência ao nível',
      () async {
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

        // Execute: 100 sorteios em nível 6
        final resultados = <int>[];
        for (int i = 0; i < 100; i++) {
          final pergunta = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: 6,
          );
          resultados.add(pergunta.dificuldade);
        }

        // Verify: dificuldade 6 e próximas (5-7) devem ser predominantes
        final proximasAlvo = resultados.where((d) => d >= 5 && d <= 7).length;
        final percentualProximasAlvo = (proximasAlvo / resultados.length) * 100;

        expect(
          percentualProximasAlvo,
          greaterThanOrEqualTo(50),
          reason:
              'Esperado 50% de dificuldade 5-7 em nível 6, obteve $percentualProximasAlvo%',
        );
      },
    );

    test(
      'Distribuição de dificuldade em nível 7 com aderência ao nível',
      () async {
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

        // Execute: 100 sorteios em nível 7
        final resultados = <int>[];
        for (int i = 0; i < 100; i++) {
          final pergunta = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: 7,
          );
          resultados.add(pergunta.dificuldade);
        }

        // Verify: dificuldade 7 e próximas (6-8) devem ser predominantes
        final proximasAlvo = resultados.where((d) => d >= 6 && d <= 8).length;
        final percentualProximasAlvo = (proximasAlvo / resultados.length) * 100;

        expect(
          percentualProximasAlvo,
          greaterThanOrEqualTo(50),
          reason:
              'Esperado 50% de dificuldade 6-8 em nível 7, obteve $percentualProximasAlvo%',
        );
      },
    );

    test('Distribuição em nível médio mantém aleatoriedade', () async {
      // Setup: perguntas com diferentes dificuldades
      final perguntas = <Pergunta>[];
      for (int dif = 1; dif <= 10; dif++) {
        for (int i = 0; i < 20; i++) {
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

      // Execute: 150 sorteios em nível 5
      final idsUnicas = <String>{};
      for (int i = 0; i < 150; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 5,
        );
        idsUnicas.add(pergunta.id);
      }

      // Verify: deve ter pelo menos 50 IDs únicos em 150 sorteios
      expect(
        idsUnicas.length,
        greaterThanOrEqualTo(50),
        reason:
            'Esperado aleatoriedade (>50 IDs únicos em 150 sorteios), obteve ${idsUnicas.length}',
      );
    });
  });
}
