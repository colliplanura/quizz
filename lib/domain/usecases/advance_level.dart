import '../entities/partida.dart';
import '../entities/pergunta.dart';
import '../entities/progresso.dart';
import '../repositories/pergunta_repository.dart';
import '../repositories/progresso_repository.dart';
import '../../data/models/partida_model.dart';
import 'selecionar_pergunta.dart';

class AdvanceLevel {
  AdvanceLevel({
    required this.perguntaRepository,
    required this.progressoRepository,
    required this.selecionarPergunta,
  });

  final PerguntaRepository perguntaRepository;
  final ProgressoRepository progressoRepository;
  final SelecionarPergunta selecionarPergunta;

  Future<({Partida novaPartida, Progresso progresso, Pergunta proximaPergunta})>
  executar(Progresso progressoAtual) async {
    final novoNivel = progressoAtual.nivelAtual + 1;
    final novoProgresso = progressoAtual.copyWith(
      nivelAtual: novoNivel,
      acertosConsecutivos: 0,
      errosConsecutivos: 0,
      trofeusGanhos:
          progressoAtual.trofeusGanhos + 1, // ganha 1 troféu ao subir nível
    );

    final perguntas = await perguntaRepository.obterTodasPerguntas();
    final proxima = await selecionarPergunta.executar(
      perguntas: perguntas,
      nivel: novoNivel,
    );

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
