import '../domain/entities/partida.dart';
import '../domain/entities/progresso.dart';
import '../domain/repositories/progresso_repository.dart';
import 'logging_service.dart';

class GameStatePersistenceService {
  GameStatePersistenceService(this._progressoRepository);

  final ProgressoRepository _progressoRepository;

  Future<void> persistirEstado({
    required Partida partida,
    required Progresso progresso,
  }) async {
    try {
      await _progressoRepository.salvarPartida(partida);
      await _progressoRepository.salvarProgresso(progresso);
    } catch (e, st) {
      LoggingService.error(
        'Falha ao persistir estado do jogo',
        erro: e,
        stackTrace: st,
        contexto: 'GameStatePersistenceService',
      );
    }
  }

  Future<({Partida? partida, Progresso? progresso})> restaurarEstado() async {
    try {
      final progresso = await _progressoRepository.obterProgresso();
      final partida = await _progressoRepository.obterPartidaAtiva();
      return (partida: partida, progresso: progresso);
    } catch (e, st) {
      LoggingService.error(
        'Falha ao restaurar estado do jogo',
        erro: e,
        stackTrace: st,
        contexto: 'GameStatePersistenceService',
      );
      return (partida: null, progresso: null);
    }
  }
}
