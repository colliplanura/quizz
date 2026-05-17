import 'package:equatable/equatable.dart';

class Trofeu extends Equatable {
  const Trofeu({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.descricao,
    required this.dataGanho,
    this.iconeUrl,
    this.pontosBonus,
  });

  final String id;
  final String tipo;
  final String nome;
  final String descricao;
  final DateTime dataGanho;
  final String? iconeUrl;
  final int? pontosBonus;

  @override
  List<Object?> get props => [id, tipo, nome, descricao, dataGanho, iconeUrl, pontosBonus];
}
