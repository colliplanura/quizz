import '../../domain/repositories/sync_repository.dart';
import '../../domain/repositories/pergunta_repository.dart';
import '../datasources/remote/github_remote_source.dart';
import '../../services/question_payload_validator_service.dart';
import '../../services/logging_service.dart';
import '../../utils/constants.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl({
    required this.remoteSource,
    required this.perguntaRepository,
  });

  final GithubRemoteSource remoteSource;
  final PerguntaRepository perguntaRepository;
  DateTime? _ultimaSincronizacao;

  @override
  Future<bool> sincronizarPerguntas() async {
    try {
      final perguntas = await remoteSource.obterPerguntas();
      final validas = QuestionPayloadValidatorService.validar(perguntas);
      if (validas.isEmpty && await perguntaRepository.temPerguntas()) {
        LoggingService.warning(
          'Payload 100% inválido — mantendo cache local',
          contexto: 'SyncRepository',
        );
        return false;
      }
      await perguntaRepository.salvarPerguntas(validas);
      _ultimaSincronizacao = DateTime.now();
      LoggingService.info(
        'Sync concluído: ${validas.length} perguntas salvas',
        contexto: 'SyncRepository',
      );
      return true;
    } catch (e, st) {
      LoggingService.error(
        'Falha de sync: $e',
        erro: e,
        stackTrace: st,
        contexto: 'SyncRepository',
      );
      return false;
    }
  }

  @override
  Future<DateTime?> obterUltimaSincronizacao() async => _ultimaSincronizacao;

  @override
  Future<bool> deveeSincronizar() async {
    if (_ultimaSincronizacao == null) return true;
    return DateTime.now().difference(_ultimaSincronizacao!) > GameConstants.intervaloSync;
  }
}
