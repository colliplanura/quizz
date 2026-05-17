import 'dart:math';

import '../../data/datasources/local/historico_pergunta_local_datasource.dart';
import '../../utils/constants.dart';
import '../entities/pergunta.dart';

class SelecionarPergunta {
  SelecionarPergunta({
    required HistoricoPerguntaLocalDatasource historicoDatasource,
    Random? random,
  }) : _historicoDatasource = historicoDatasource,
       _random = random ?? Random();

  final HistoricoPerguntaLocalDatasource _historicoDatasource;
  final Random _random;

  Future<Pergunta> executar({
    required List<Pergunta> perguntas,
    required int nivel,
  }) async {
    if (perguntas.isEmpty) {
      throw StateError('Sem perguntas disponíveis');
    }

    final agora = DateTime.now();
    final historico = await _historicoDatasource.obterHistorico();

    var elegiveis = _filtrarElegiveis(
      perguntas: perguntas,
      historico: historico,
      referencia: agora,
    );

    // Regra de fallback: se o pool elegível esgotar, limpar histórico e retomar sorteio.
    if (elegiveis.isEmpty) {
      await _historicoDatasource.limparHistorico();
      elegiveis = List<Pergunta>.from(perguntas);
    }

    final selecionada = _sortearPonderadoPorDificuldade(elegiveis, nivel);
    await _historicoDatasource.marcarPerguntaRespondida(selecionada.id, agora);

    return selecionada;
  }

  List<Pergunta> _filtrarElegiveis({
    required List<Pergunta> perguntas,
    required Map<String, DateTime> historico,
    required DateTime referencia,
  }) {
    return perguntas.where((pergunta) {
      final ultimaVez = historico[pergunta.id];
      if (ultimaVez == null) return true;

      return referencia.difference(ultimaVez) >=
          GameConstants.janelaAntiRepeticao;
    }).toList();
  }

  Pergunta _sortearPonderadoPorDificuldade(
    List<Pergunta> elegiveis,
    int nivel,
  ) {
    final nivelNormalizado = nivel.clamp(1, 10);

    final pesos = <double>[];
    var somaPesos = 0.0;
    for (final pergunta in elegiveis) {
      final peso = _pesoPorNivelEDificuldade(
        nivel: nivelNormalizado,
        dificuldade: pergunta.dificuldade,
      );
      pesos.add(peso);
      somaPesos += peso;
    }

    if (somaPesos <= 0) {
      return elegiveis[_random.nextInt(elegiveis.length)];
    }

    final alvo = _random.nextDouble() * somaPesos;
    var acumulado = 0.0;
    for (var i = 0; i < elegiveis.length; i++) {
      acumulado += pesos[i];
      if (alvo <= acumulado) {
        return elegiveis[i];
      }
    }

    return elegiveis.last;
  }

  double _pesoPorNivelEDificuldade({
    required int nivel,
    required int dificuldade,
  }) {
    if (nivel <= 3) {
      if (dificuldade <= 3) return 10.0;
      if (dificuldade <= 7) return 2.0;
      return 1.0;
    }

    if (nivel >= 8) {
      if (dificuldade >= 8) return 10.0;
      if (dificuldade >= 4) return 2.0;
      return 1.0;
    }

    final alvo = nivel;
    final distancia = (dificuldade - alvo).abs();
    switch (distancia) {
      case 0:
        return 10.0;
      case 1:
        return 7.0;
      case 2:
        return 4.0;
      case 3:
        return 2.0;
      default:
        return 1.0;
    }
  }
}
