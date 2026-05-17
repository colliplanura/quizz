import '../../domain/entities/trofeu.dart';

class TrofeuModel extends Trofeu {
  const TrofeuModel({
    required super.id,
    required super.tipo,
    required super.nome,
    required super.descricao,
    required super.dataGanho,
    super.iconeUrl,
    super.pontosBonus,
  });

  factory TrofeuModel.fromHive(Map<dynamic, dynamic> map) {
    final json = map.map((k, v) => MapEntry(k.toString(), v));
    return TrofeuModel(
      id: json['id'] as String,
      tipo: json['tipo'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      dataGanho: DateTime.parse(json['data_ganho'] as String),
      iconeUrl: json['icone_url'] as String?,
      pontosBonus: json['pontos_bonus'] as int?,
    );
  }

  Map<String, dynamic> toHive() => {
        'id': id,
        'tipo': tipo,
        'nome': nome,
        'descricao': descricao,
        'data_ganho': dataGanho.toIso8601String(),
        if (iconeUrl != null) 'icone_url': iconeUrl,
        if (pontosBonus != null) 'pontos_bonus': pontosBonus,
      };
}
