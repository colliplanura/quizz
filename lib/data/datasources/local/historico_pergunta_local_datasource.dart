import '../../../utils/constants.dart';
import 'hive_service.dart';

class HistoricoPerguntaLocalDatasource {
  Future<Map<String, DateTime>> obterHistorico() async {
    await HiveService.garantirInicializado();
    final raw = HiveService.config.get(
      GameConstants.keyHistoricoPerguntasRespondidas,
    );
    if (raw == null) return <String, DateTime>{};

    final map = raw.map((k, v) => MapEntry(k.toString(), v));
    final historico = <String, DateTime>{};
    for (final entry in map.entries) {
      if (entry.value is String) {
        final parsed = DateTime.tryParse(entry.value as String);
        if (parsed != null) {
          historico[entry.key] = parsed;
        }
      }
    }
    return historico;
  }

  Future<void> salvarHistorico(Map<String, DateTime> historico) async {
    await HiveService.garantirInicializado();
    final serializado = {
      for (final entry in historico.entries)
        entry.key: entry.value.toIso8601String(),
    };
    await HiveService.config.put(
      GameConstants.keyHistoricoPerguntasRespondidas,
      serializado,
    );
  }

  Future<void> marcarPerguntaRespondida(
    String perguntaId,
    DateTime quando,
  ) async {
    final historico = await obterHistorico();
    historico[perguntaId] = quando;
    await salvarHistorico(historico);
  }

  Future<void> limparHistorico() async {
    await HiveService.garantirInicializado();
    await HiveService.config.delete(
      GameConstants.keyHistoricoPerguntasRespondidas,
    );
  }
}
