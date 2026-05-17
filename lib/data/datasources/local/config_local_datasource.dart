import '../../models/configuracao_idioma_model.dart';
import 'hive_service.dart';

class ConfigLocalDatasource {
  static const String _key = 'config_idioma';

  Future<ConfiguracaoIdiomaModel> obterConfig() async {
    await HiveService.garantirInicializado();
    final raw = HiveService.config.get(_key);
    if (raw == null) return ConfiguracaoIdiomaModel.padrao();
    return ConfiguracaoIdiomaModel.fromHive(raw);
  }

  Future<void> salvarConfig(ConfiguracaoIdiomaModel config) async {
    await HiveService.garantirInicializado();
    await HiveService.config.put(_key, config.toHive());
  }
}
