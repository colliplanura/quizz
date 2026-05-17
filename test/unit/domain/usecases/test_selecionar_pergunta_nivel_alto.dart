import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:math';

import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';

@GenerateMocks([HistoricoPerguntaLocalDatasource])
import 'test_selecionar_pergunta_nivel_alto.mocks.dart';

void main() {
  late MockHistoricoPerguntaLocalDatasource mockHistoricoDatasource;
  late SelecionarPergunta selecionarPergunta;

  setUp(() {
    mockHistoricoDatasource = MockHistoricoPerguntaLocalDatasource();
    selecionarPergunta = SelecionarPergunta(
      historicoDatasource: mockHistoricoDatasource,
      random: Random(456),
    );
  });

  group('SelecionarPergunta - Nível Alto (8-10)', () {
    test('Distribuição de dificuldade em nível 8 predomínio de 8-10', () async {
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

      // Execute: 100 sorteios em nível 8
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 8,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: ao menos 70% deve ser dificuldade 8-10
      final altas = resultados.where((d) => d >= 8).length;
      final percentualAlto = (altas / resultados.length) * 100;

      expect(
        percentualAlto,
        greaterThanOrEqualTo(70),
        reason:
            'Esperado 70% de dificuldade 8-10 em nível 8, obteve $percentualAlto%',
      );
    });

    test('Distribuição de dificuldade em nível 9 predomínio de 8-10', () async {
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

      // Execute: 100 sorteios em nível 9
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 9,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: ao menos 70% deve ser dificuldade 8-10
      final altas = resultados.where((d) => d >= 8).length;
      final percentualAlto = (altas / resultados.length) * 100;

      expect(
        percentualAlto,
        greaterThanOrEqualTo(70),
        reason:
            'Esperado 70% de dificuldade 8-10 em nível 9, obteve $percentualAlto%',
      );
    });

    test('Distribuição de dificuldade em nível 10 predomínio de 8-10', () async {
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

      // Execute: 100 sorteios em nível 10
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 10,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: ao menos 70% deve ser dificuldade 8-10
      final altas = resultados.where((d) => d >= 8).length;
      final percentualAlto = (altas / resultados.length) * 100;

      expect(
        percentualAlto,
        greaterThanOrEqualTo(70),
        reason:
            'Esperado 70% de dificuldade 8-10 em nível 10, obteve $percentualAlto%',
      );
    });

    test('Distribuição possui aleatoriedade dentro da faixa alvo', () async {
      // Setup: 50 perguntas com dificuldade 8-10
      final perguntas = <Pergunta>[];
      for (int dif = 8; dif <= 10; dif++) {
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
          nivel: 9,
        );
        idsUnicas.add(pergunta.id);
      }

      // Verify: deve ter pelo menos 30 IDs únicos em 100 sorteios
      expect(
        idsUnicas.length,
        greaterThanOrEqualTo(30),
        reason:
            'Esperado aleatoriedade (>30 IDs únicos em 100 sorteios), obteve ${idsUnicas.length}',
      );
    });

    test('Distribuição em nível alto favorece dificuldades mais altas', () async {
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

      // Execute: 100 sorteios em nível 9
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 9,
        );
        resultados.add(pergunta.dificuldade);
      }

      // Verify: dificuldade 8-10 deve ter mais sorteios que 1-3
      final altas = resultados.where((d) => d >= 8).length;
      final baixas = resultados.where((d) => d <= 3).length;

      expect(
        altas,
        greaterThan(baixas),
        reason:
            'Esperado mais sorteios de dificuldade alta (8-10) que baixa (1-3) em nível 9. Altas: $altas, Baixas: $baixas',
      );
    });
  });
}
