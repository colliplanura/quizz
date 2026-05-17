import 'dart:math';

import '../../data/datasources/local/historico_pergunta_local_datasource.dart';
import '../../utils/constants.dart';
import '../entities/pergunta.dart';

/// AntiRepeticaoUseCase
/// Implementa a regra de anti-repetição por 2 horas (wall-clock)
/// com fallback de reset de histórico quando o pool elegível fica vazio.
class AntiRepeticaoUseCase {
  AntiRepeticaoUseCase({
    required HistoricoPerguntaLocalDatasource historicoDatasource,
    Random? random,
  }) : _historicoDatasource = historicoDatasource,
       _random = random ?? Random();

  final HistoricoPerguntaLocalDatasource _historicoDatasource;
  final Random _random;

  /// Executa a seleção de pergunta com anti-repetição de 2h wall-clock e fallback
  ///
  /// Parâmetros:
  /// - perguntas: lista de todas as perguntas disponíveis
  /// - nivel: nível de jogo atual (para ponderação de dificuldade, se aplicável)
  ///
  /// Retorna:
  /// - pergunta selecionada (elegível para anti-repetição)
  ///
  /// Comportamento:
  /// 1. Filtra perguntas respondidas há menos de 2h (inelegíveis)
  /// 2. Se pool elegível ficar vazio, limpa histórico e retorna ao normal
  /// 3. Sorteia aleatoriamente entre as elegíveis
  Future<Pergunta> executar({
    required List<Pergunta> perguntas,
    required int nivel,
  }) async {
    if (perguntas.isEmpty) {
      throw StateError('Sem perguntas disponíveis para anti-repetição');
    }

    final agora = DateTime.now();
    final historico = await _historicoDatasource.obterHistorico();

    // Filtrar perguntas elegíveis respeitando a janela de 2h
    var elegiveis = _filtrarElegiveis(
      perguntas: perguntas,
      historico: historico,
      referencia: agora,
    );

    // Regra de fallback: se o pool elegível esgotar, limpar histórico
    if (elegiveis.isEmpty) {
      await _historicoDatasource.limparHistorico();
      elegiveis = List<Pergunta>.from(perguntas);
    }

    // Sortear aleatoriamente entre as elegíveis
    final selecionada = elegiveis[_random.nextInt(elegiveis.length)];

    // Registrar que a pergunta foi respondida (agora em wall-clock)
    await _historicoDatasource.marcarPerguntaRespondida(selecionada.id, agora);

    return selecionada;
  }

  /// Filtra perguntas elegíveis respeitando a janela de anti-repetição de 2 horas
  ///
  /// Uma pergunta é elegível se:
  /// - Nunca foi respondida, OU
  /// - Foi respondida há 2 horas ou mais (wall-clock)
  List<Pergunta> _filtrarElegiveis({
    required List<Pergunta> perguntas,
    required Map<String, DateTime> historico,
    required DateTime referencia,
  }) {
    return perguntas.where((pergunta) {
      // Se a pergunta nunca foi respondida, é elegível
      if (!historico.containsKey(pergunta.id)) {
        return true;
      }

      // Verificar se a pergunta foi respondida há 2 horas ou mais
      final respondidaEm = historico[pergunta.id]!;
      final tempoDecorrido = referencia.difference(respondidaEm);

      return tempoDecorrido >= GameConstants.janelaAntiRepeticao;
    }).toList();
  }

  /// Verifica se uma pergunta específica é elegível
  /// Útil para validação em testes e diagnóstico
  Future<bool> estaElegivel(String perguntaId) async {
    final historico = await _historicoDatasource.obterHistorico();

    if (!historico.containsKey(perguntaId)) {
      return true; // Nunca respondida
    }

    final respondidaEm = historico[perguntaId]!;
    final agora = DateTime.now();
    final tempoDecorrido = agora.difference(respondidaEm);

    return tempoDecorrido >= GameConstants.janelaAntiRepeticao;
  }

  /// Retorna quantas perguntas estão atualmente no histórico
  /// Útil para diagnóstico
  Future<int> obterTamanhoCacheHistorico() async {
    final historico = await _historicoDatasource.obterHistorico();
    return historico.length;
  }

  /// Retorna a data/hora que uma pergunta estará elegível novamente
  /// Se já está elegível, retorna DateTime.now()
  Future<DateTime> obterDataElegibilidade(String perguntaId) async {
    final historico = await _historicoDatasource.obterHistorico();

    if (!historico.containsKey(perguntaId)) {
      return DateTime.now(); // Já elegível
    }

    final respondidaEm = historico[perguntaId]!;
    final dataElegivel = respondidaEm.add(GameConstants.janelaAntiRepeticao);

    return dataElegivel;
  }
}
