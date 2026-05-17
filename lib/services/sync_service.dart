import '../domain/usecases/sync_questions.dart';
import 'logging_service.dart';

class SyncService {
  SyncService(this._syncQuestions);

  final SyncQuestions _syncQuestions;

  /// Dispara sync silenciosamente (fire-and-forget) sem bloquear UI
  void sincronizarEmBackground({bool forcarSync = false}) {
    _executarSync(forcarSync: forcarSync);
  }

  Future<void> _executarSync({bool forcarSync = false}) async {
    try {
      final sincronizado = await _syncQuestions.executar(forcarSync: forcarSync);
      if (sincronizado) {
        LoggingService.info('Background sync concluído', contexto: 'SyncService');
      }
    } catch (e, st) {
      LoggingService.error(
        'Background sync falhou silenciosamente',
        erro: e,
        stackTrace: st,
        contexto: 'SyncService',
      );
    }
  }
}
