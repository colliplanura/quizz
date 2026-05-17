abstract class SyncRepository {
  Future<bool> sincronizarPerguntas();
  Future<DateTime?> obterUltimaSincronizacao();
  Future<bool> deveeSincronizar();
}
