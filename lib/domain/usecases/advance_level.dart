import '../entities/partida.dart';
import '../entities/pergunta.dart';
import '../entities/progresso.dart';
import '../repositories/pergunta_repository.dart';
import '../repositories/progresso_repository.dart';
import '../../data/models/partida_model.dart';

class AdvanceLevel {
  AdvanceLevel({
    required this.perguntaRepository,
    required this.progressoRepository,
  });

  final PerguntaRepository perguntaRepository;
  final ProgressoRepository progressoRepository;

  Future<({Partida novaPartida, Progresso progresso, Pergunta proximaPergunta})> executar(
    Progresso progressoAtual,
  ) async {
    final novoNivel = progressoAtual.nivelAtual + 1;
    final novoProgresso = progressoAtual.copyWith(
      nivelAtual: novoNivel,
      acertosConsecutivos: 0,
      errosConsecutivos: 0,
      trofeusGanhos: progressoAtual.trofeusGanhos + 1, // ganha 1 troféu ao subir nível
    );

    final perguntas = await perguntaRepository.obterTodasPerguntas();
    final dificuldadeAlvo = ((novoNivel - 1) % 10) + 1;
    final candidatas = perguntas.where((p) => p.dificuldade == dificuldadeAlvo).toList();
    final proxima = candidatas.isNotEmpty
        ? candidatas[novoNivel % candidatas.length]
        : perguntas[novoNivel % perguntas.length];

    final novaPartida = PartidaModel.nova(
      nivel: novoNivel,
      perguntaAtualId: proxima.id,
    );

    await progressoRepository.salvarPartida(novaPartida);
    await progressoRepository.salvarProgresso(
      novoProgresso.copyWith(partidaAtivaId: novaPartida.id),
    );

    return (
      novaPartida: novaPartida,
      progresso: novoProgresso,
      proximaPergunta: proxima,
    );
  }
}
