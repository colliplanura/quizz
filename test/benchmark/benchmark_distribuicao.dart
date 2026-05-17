import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';

class _FakeHistoricoPerguntaLocalDatasource
    extends HistoricoPerguntaLocalDatasource {
  final Map<String, DateTime> _historico = {};

  @override
  Future<Map<String, DateTime>> obterHistorico() async =>
      Map<String, DateTime>.from(_historico);

  @override
  Future<void> salvarHistorico(Map<String, DateTime> historico) async {
    _historico
      ..clear()
      ..addAll(historico);
  }

  @override
  Future<void> marcarPerguntaRespondida(
    String perguntaId,
    DateTime quando,
  ) async {
    _historico[perguntaId] = quando;
  }

  @override
  Future<void> limparHistorico() async {
    _historico.clear();
  }
}

List<Pergunta> _criarBasePerguntasVariada() {
  final perguntas = <Pergunta>[];
  for (int dif = 1; dif <= 10; dif++) {
    for (int i = 0; i < 60; i++) {
      perguntas.add(
        Pergunta(
          id: 'pergunta-$dif-$i',
          pergunta: 'Pergunta $dif-$i',
          resposta: 'resposta',
          exibicaoResposta: 'Resposta',
          categoria: 'categoria-$dif',
          dificuldade: dif,
          contextoHistorico: {'pt_BR': 'Contexto $dif'},
        ),
      );
    }
  }
  return perguntas;
}

double _percentualFaixa(List<int> valores, int min, int max) {
  final totalFaixa = valores.where((v) => v >= min && v <= max).length;
  return (totalFaixa / valores.length) * 100;
}

Duration _p95(List<Duration> amostras) {
  final ordenado = List<Duration>.from(amostras)..sort();
  final idx = ((ordenado.length * 0.95).floor()).clamp(0, ordenado.length - 1);
  return ordenado[idx];
}

void main() {
  group('Benchmark Distribuicao Dificuldade', () {
    test('SC-002/SC-003: 300 sorteios deterministicos por faixa', () async {
      final perguntas = _criarBasePerguntasVariada();

      final baixo = <int>[];
      final alto = <int>[];

      for (final nivel in [1, 2, 3]) {
        for (int i = 0; i < 100; i++) {
          final selecionarPergunta = SelecionarPergunta(
            historicoDatasource: _FakeHistoricoPerguntaLocalDatasource(),
            random: Random(20260517 + (nivel * 1000) + i),
          );
          final p = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: nivel,
          );
          baixo.add(p.dificuldade);
        }
      }

      for (final nivel in [8, 9, 10]) {
        for (int i = 0; i < 100; i++) {
          final selecionarPergunta = SelecionarPergunta(
            historicoDatasource: _FakeHistoricoPerguntaLocalDatasource(),
            random: Random(20260517 + (nivel * 1000) + i),
          );
          final p = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: nivel,
          );
          alto.add(p.dificuldade);
        }
      }

      final pBaixo = _percentualFaixa(baixo, 1, 3);
      final pAlto = _percentualFaixa(alto, 8, 10);
      print("METRIC_pBaixo: $pBaixo%, METRIC_pAlto: $pAlto%");

      expect(pBaixo, greaterThanOrEqualTo(70));
      expect(pAlto, greaterThanOrEqualTo(70));
    });

    test('p95 de sorteio por operacao <= 200ms', () async {
      final perguntas = _criarBasePerguntasVariada();
      final datasource = _FakeHistoricoPerguntaLocalDatasource();
      final selecionarPergunta = SelecionarPergunta(
        historicoDatasource: datasource,
        random: Random(42),
      );

      final amostras = <Duration>[];
      for (int i = 0; i < 90; i++) {
        final nivel = (i % 10) + 1;
        final sw = Stopwatch()..start();
        await selecionarPergunta.executar(perguntas: perguntas, nivel: nivel);
        sw.stop();
        amostras.add(sw.elapsed);
      }

      final p95 = _p95(amostras);
      print("METRIC_p95: ${p95.inMilliseconds}ms");
      expect(p95.inMilliseconds, lessThanOrEqualTo(200));
    });
  });
}
