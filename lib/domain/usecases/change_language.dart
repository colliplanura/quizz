import '../entities/configuracao_idioma.dart';
import '../../data/datasources/local/configuracao_idioma_local_source.dart';
import '../../data/models/configuracao_idioma_model.dart';
import '../../config/localization.dart';

class ChangeLanguage {
  ChangeLanguage(this._source);

  final ConfiguracaoIdiomaLocalSource _source;

  Future<ConfiguracaoIdioma> obterIdioma() => _source.obterConfig();

  Future<ConfiguracaoIdioma> alterarIdioma(String codigoIdioma) async {
    final suportado = AppLocalization.supportedLocales
        .any((l) => '${l.languageCode}_${l.countryCode}' == codigoIdioma ||
            l.languageCode == codigoIdioma.split('_').first);
    if (!suportado) {
      throw ArgumentError('Idioma não suportado: $codigoIdioma');
    }
    final config = ConfiguracaoIdiomaModel(
      id: 'config_idioma',
      idiomaPreferido: codigoIdioma,
      dataAlteracao: DateTime.now(),
    );
    await _source.salvarConfig(config);
    return config;
  }
}
