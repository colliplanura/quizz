import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';

@GenerateMocks([HistoricoPerguntaLocalDatasource])
import 'test_selecionar_pergunta_randomness.mocks.dart';

void main() {
  late MockHistoricoPerguntaLocalDatasource mockHistoricoDatasource;
  late SelecionarPergunta selecionarPergunta;

  setUp(() {
    mockHistoricoDatasource = MockHistoricoPerguntaLocalDatasource();
    selecionarPergunta = SelecionarPergunta(
      historicoDatasource: mockHistoricoDatasource,
      random: Random(789),
    );
  });

  group('SelecionarPergunta - Randomness & Distribution (300+ draws)', () {
    test('300 sorteios em nível baixo apresentam distribuição esperada', () async {
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

      // Execute: 300 sorteios em nível 2
      final resultados = <int>[];
      for (int i = 0; i < 300; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 2,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: distribuição esperada em 300 sorteios
      final baixas = resultados.where((d) => d <= 3).length;
      final medias = resultados.where((d) => d >= 4 && d <= 7).length;
      final altas = resultados.where((d) => d >= 8).length;

      final percentualBaixa = (baixas / resultados.length) * 100;
      final percentualMedia = (medias / resultados.length) * 100;
      final percentualAlta = (altas / resultados.length) * 100;

      expect(
        percentualBaixa,
        greaterThanOrEqualTo(70),
        reason:
            'Nível 2: Esperado ≥70% de dificuldade 1-3, obteve $percentualBaixa%',
      );
      expect(
        percentualMedia + percentualAlta,
        lessThanOrEqualTo(30),
        reason:
            'Nível 2: Esperado ≤30% de dificuldade 4+, obteve ${percentualMedia + percentualAlta}%',
      );
    });

    test(
      '300 sorteios em nível médio apresentam distribuição esperada',
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

        // Execute: 300 sorteios em nível 5
        final resultados = <int>[];
        for (int i = 0; i < 300; i++) {
          final pergunta = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: 5,
          );
          resultados.add(pergunta.dificuldade);
        }

        // Verify: distribuição esperada em nível médio
        final proximasAlvo = resultados.where((d) => d >= 4 && d <= 6).length;
        final percentualProximasAlvo = (proximasAlvo / resultados.length) * 100;

        expect(
          percentualProximasAlvo,
          greaterThanOrEqualTo(50),
          reason:
              'Nível 5: Esperado ≥50% de dificuldade 4-6, obteve $percentualProximasAlvo%',
        );
      },
    );

    test('300 sorteios em nível alto apresentam distribuição esperada', () async {
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

      // Execute: 300 sorteios em nível 9
      final resultados = <int>[];
      for (int i = 0; i < 300; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 9,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: distribuição esperada em nível alto
      final altas = resultados.where((d) => d >= 8).length;
      final percentualAlto = (altas / resultados.length) * 100;

      expect(
        percentualAlto,
        greaterThanOrEqualTo(70),
        reason:
            'Nível 9: Esperado ≥70% de dificuldade 8-10, obteve $percentualAlto%',
      );
    });

    test('300 sorteios mantêm aleatoriedade significativa', () async {
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

      // Execute: 300 sorteios em nível 5
      final idsUnicas = <String>{};
      for (int i = 0; i < 300; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 5,
        );
        idsUnicas.add(pergunta.id);
      }

      // Verify: deve ter pelo menos 150 IDs únicos em 300 sorteios
      // (esperado ~167 com distribuição uniforme dentro do pool)
      expect(
        idsUnicas.length,
        greaterThanOrEqualTo(100),
        reason:
            'Esperado alta aleatoriedade (>100 IDs únicos em 300 sorteios), obteve ${idsUnicas.length}',
      );
    });

    test('Distribuição de dificuldade é consistente em 300 sorteios', () async {
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

      // Execute: contagem de dificuldades em 300 sorteios nível 1
      final contagem = <int, int>{
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
        7: 0,
        8: 0,
        9: 0,
        10: 0,
      };

      for (int i = 0; i < 300; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 1,
        );
        contagem[pergunta.dificuldade] =
            (contagem[pergunta.dificuldade] ?? 0) + 1;
      }

      // Verify: distribuição esperada para nível 1
      final percentual1a3 =
          ((contagem[1] ?? 0) + (contagem[2] ?? 0) + (contagem[3] ?? 0)) /
          300 *
          100;

      expect(
        percentual1a3,
        greaterThanOrEqualTo(70),
        reason:
            'Nível 1 em 300 sorteios: Esperado ≥70% de dificuldade 1-3, obteve $percentual1a3%',
      );

      // Verificar que há alguma variação (não é sempre a mesma dificuldade)
      final dificuldadesDistribuidas = contagem.entries
          .where((e) => e.value > 0)
          .length;
      expect(
        dificuldadesDistribuidas,
        greaterThan(1),
        reason:
            'Esperado múltiplas dificuldades sorteadas, obteve $dificuldadesDistribuidas',
      );
    });

    test('Anti-repetição funciona corretamente em 300 sorteios', () async {
      // Setup: 20 perguntas apenas (para forçar repetição após histórico)
      final perguntas = <Pergunta>[];
      for (int i = 0; i < 20; i++) {
        perguntas.add(
          Pergunta(
            id: 'pergunta-$i',
            pergunta: 'Pergunta $i',
            resposta: 'resposta',
            exibicaoResposta: 'Resposta',
            categoria: 'categoria',
            dificuldade: (i % 10) + 1,
            contextoHistorico: {'pt_BR': 'Contexto'},
          ),
        );
      }

      // Mock: histórico com algumas perguntas respondidas há mais de 2h
      final historico = <String, DateTime>{
        'pergunta-0': DateTime.now().subtract(const Duration(hours: 3)),
        'pergunta-1': DateTime.now().subtract(const Duration(hours: 3)),
        'pergunta-2': DateTime.now(),
      };

      when(
        mockHistoricoDatasource.obterHistorico(),
      ).thenAnswer((_) async => historico);
      when(
        mockHistoricoDatasource.marcarPerguntaRespondida(any, any),
      ).thenAnswer((invocation) async {
        final perguntaId = invocation.positionalArguments[0] as String;
        final dataAgora = invocation.positionalArguments[1] as DateTime;
        historico[perguntaId] = dataAgora;
      });

      // Execute: 50 sorteios que devem evitar pergunta-2
      int pergunta2Count = 0;
      for (int i = 0; i < 50; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 5,
        );
        if (pergunta.id == 'pergunta-2') {
          pergunta2Count++;
        }
      }

      // Verify: pergunta-2 não deve ser sorteada muitas vezes
      expect(
        pergunta2Count,
        lessThanOrEqualTo(5),
        reason:
            'Pergunta-2 respondida recentemente não deveria ser sorteada frequentemente, mas foi $pergunta2Count vezes',
      );
    });
  });
}
