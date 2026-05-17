import '../../domain/entities/configuracao_idioma.dart';

class ConfiguracaoIdiomaModel extends ConfiguracaoIdioma {
  const ConfiguracaoIdiomaModel({
    required super.id,
    required super.idiomaPreferido,
    required super.dataAlteracao,
  });

  factory ConfiguracaoIdiomaModel.padrao() => ConfiguracaoIdiomaModel(
        id: 'config_idioma',
        idiomaPreferido: 'pt_BR',
        dataAlteracao: DateTime.now(),
      );

  factory ConfiguracaoIdiomaModel.fromHive(Map<dynamic, dynamic> map) {
    final json = map.map((k, v) => MapEntry(k.toString(), v));
    return ConfiguracaoIdiomaModel(
      id: json['id'] as String,
      idiomaPreferido: json['idioma_preferido'] as String,
      dataAlteracao: DateTime.parse(json['data_alteracao'] as String),
    );
  }

  Map<String, dynamic> toHive() => {
        'id': id,
        'idioma_preferido': idiomaPreferido,
        'data_alteracao': dataAlteracao.toIso8601String(),
      };
}
