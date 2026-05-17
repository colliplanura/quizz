import '../entities/partida.dart';
import '../entities/pergunta.dart';
import '../entities/progresso.dart';
import '../repositories/pergunta_repository.dart';
import '../repositories/progresso_repository.dart';
import '../../data/models/partida_model.dart';
import '../../utils/constants.dart';

class ContinueGame {
  ContinueGame({
    required this.perguntaRepository,
    required this.progressoRepository,
  });

  final PerguntaRepository perguntaRepository;
  final ProgressoRepository progressoRepository;

  Future<({Partida novaPartida, Progresso progresso, Pergunta pergunta})> continuar(
    Progresso progresso,
  ) async {
    if (progresso.trofeusGanhos < GameConstants.custoTrofeuContinuar) {
      throw StateError('Sem troféus suficientes para continuar');
    }

    final novoProgresso = progresso.copyWith(
      trofeusGanhos: progresso.trofeusGanhos - GameConstants.custoTrofeuContinuar,
      errosConsecutivos: 0,
    );

    final perguntas = await perguntaRepository.obterTodasPerguntas();
    final pergunta = perguntas[progresso.nivelAtual % perguntas.length];
    final novaPartida = PartidaModel.nova(
      nivel: progresso.nivelAtual,
      perguntaAtualId: pergunta.id,
    );

    await progressoRepository.salvarPartida(novaPartida);
    await progressoRepository.salvarProgresso(novoProgresso);

    return (novaPartida: novaPartida, progresso: novoProgresso, pergunta: pergunta);
  }

  Future<({Partida novaPartida, Progresso progresso, Pergunta pergunta})> reiniciar(
    Progresso progresso,
  ) async {
    final progressoReiniciado = progresso.copyWith(
      nivelAtual: GameConstants.nivelInicial,
      pontuacaoTotal: GameConstants.pontuacaoInicial,
      acertosConsecutivos: 0,
      errosConsecutivos: 0,
      clearPartidaAtiva: true,
    );

    await progressoRepository.limparPartidaAtiva();

    final perguntas = await perguntaRepository.obterTodasPerguntas();
    final pergunta = perguntas.first;
    final novaPartida = PartidaModel.nova(
      nivel: GameConstants.nivelInicial,
      perguntaAtualId: pergunta.id,
    );

    await progressoRepository.salvarPartida(novaPartida);
    await progressoRepository.salvarProgresso(
      progressoReiniciado.copyWith(partidaAtivaId: novaPartida.id),
    );

    return (novaPartida: novaPartida, progresso: progressoReiniciado, pergunta: pergunta);
  }
}
