import '../repositories/sync_repository.dart';
import '../../services/logging_service.dart';

class SyncQuestions {
  SyncQuestions(this._syncRepository);

  final SyncRepository _syncRepository;

  Future<bool> executar({bool forcarSync = false}) async {
    if (!forcarSync && !await _syncRepository.deveeSincronizar()) {
      LoggingService.debug('Sync ignorado: intervalo não atingido', contexto: 'SyncQuestions');
      return false;
    }
    return _syncRepository.sincronizarPerguntas();
  }
}
