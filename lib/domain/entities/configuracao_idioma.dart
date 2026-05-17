import 'package:equatable/equatable.dart';

class ConfiguracaoIdioma extends Equatable {
  const ConfiguracaoIdioma({
    required this.id,
    required this.idiomaPreferido,
    required this.dataAlteracao,
  });

  final String id;
  final String idiomaPreferido;
  final DateTime dataAlteracao;

  ConfiguracaoIdioma copyWith({String? idiomaPreferido}) {
    return ConfiguracaoIdioma(
      id: id,
      idiomaPreferido: idiomaPreferido ?? this.idiomaPreferido,
      dataAlteracao: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, idiomaPreferido, dataAlteracao];
}
