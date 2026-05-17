import '../../../utils/constants.dart';
import '../../models/progresso_model.dart';
import '../../models/partida_model.dart';
import '../../models/trofeu_model.dart';
import 'hive_service.dart';

class ProgressoLocalDatasource {
  Future<ProgressoModel?> obterProgresso() async {
    await HiveService.garantirInicializado();
    final raw = HiveService.progresso.get(GameConstants.idProgressoJogador);
    if (raw == null) return null;
    return ProgressoModel.fromHive(raw);
  }

  Future<void> salvarProgresso(ProgressoModel progresso) async {
    await HiveService.garantirInicializado();
    await HiveService.progresso.put(progresso.id, progresso.toHive());
  }

  Future<PartidaModel?> obterPartidaAtiva() async {
    await HiveService.garantirInicializado();
    final box = HiveService.partida;
    if (box.isEmpty) return null;
    final raw = box.values.first;
    return PartidaModel.fromHive(raw);
  }

  Future<void> salvarPartida(PartidaModel partida) async {
    await HiveService.garantirInicializado();
    await HiveService.partida.put(partida.id, partida.toHive());
  }

  Future<void> limparPartidaAtiva() async {
    await HiveService.garantirInicializado();
    await HiveService.partida.clear();
  }

  Future<List<TrofeuModel>> obterTrofeus() async {
    await HiveService.garantirInicializado();
    return HiveService.trofeus.values
        .map((m) => TrofeuModel.fromHive(m))
        .toList();
  }

  Future<void> salvarTrofeu(TrofeuModel trofeu) async {
    await HiveService.garantirInicializado();
    await HiveService.trofeus.put(trofeu.id, trofeu.toHive());
  }
}
