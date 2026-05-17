import '../entities/partida.dart';
import '../entities/progresso.dart';
import '../repositories/progresso_repository.dart';
import '../../utils/constants.dart';

class GameOver {
  GameOver({required this.progressoRepository});

  final ProgressoRepository progressoRepository;

  Future<({Partida partidaFinalizada, bool podeContinuar})> executar(
    Partida partida,
    Progresso progresso,
  ) async {
    final finalizada = partida.copyWith(estado: EstadoPartida.gameOver);
    await progressoRepository.salvarPartida(finalizada);

    final podeContinuar =
        progresso.trofeusGanhos >= GameConstants.custoTrofeuContinuar;

    return (partidaFinalizada: finalizada, podeContinuar: podeContinuar);
  }
}
