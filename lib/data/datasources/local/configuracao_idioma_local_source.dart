import '../../../domain/entities/configuracao_idioma.dart';
import '../../models/configuracao_idioma_model.dart';
import 'hive_service.dart';

class ConfiguracaoIdiomaLocalSource {
  static const String _key = 'config_idioma';

  Future<ConfiguracaoIdioma> obterConfig() async {
    await HiveService.garantirInicializado();
    final raw = HiveService.config.get(_key);
    if (raw == null) return ConfiguracaoIdiomaModel.padrao();
    return ConfiguracaoIdiomaModel.fromHive(raw);
  }

  Future<void> salvarConfig(ConfiguracaoIdioma config) async {
    await HiveService.garantirInicializado();
    final model = config is ConfiguracaoIdiomaModel
        ? config
        : ConfiguracaoIdiomaModel(
            id: config.id,
            idiomaPreferido: config.idiomaPreferido,
            dataAlteracao: config.dataAlteracao,
          );
    await HiveService.config.put(_key, model.toHive());
  }
}
