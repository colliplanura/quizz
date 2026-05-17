import 'dart:convert';
import '../../domain/entities/partida.dart';
import 'package:uuid/uuid.dart';

class PartidaModel extends Partida {
  const PartidaModel({
    required super.id,
    required super.nivel,
    required super.acertosNesteNivel,
    required super.errosConsecutivos,
    required super.perguntaAtualId,
    required super.letrasAdivinhadas,
    required super.letrasErradas,
    required super.estado,
    required super.dataCriacao,
  });

  factory PartidaModel.nova({required int nivel, required String perguntaAtualId}) {
    return PartidaModel(
      id: const Uuid().v4(),
      nivel: nivel,
      acertosNesteNivel: 0,
      errosConsecutivos: 0,
      perguntaAtualId: perguntaAtualId,
      letrasAdivinhadas: const [],
      letrasErradas: const [],
      estado: EstadoPartida.emAndamento,
      dataCriacao: DateTime.now(),
    );
  }

  factory PartidaModel.fromHive(Map<dynamic, dynamic> map) {
    final json = map.map((k, v) => MapEntry(k.toString(), v));
    return PartidaModel(
      id: json['id'] as String,
      nivel: json['nivel'] as int,
      acertosNesteNivel: json['acertos_neste_nivel'] as int,
      errosConsecutivos: json['erros_consecutivos'] as int,
      perguntaAtualId: json['pergunta_atual_id'] as String,
      letrasAdivinhadas: List<String>.from(jsonDecode(json['letras_adivinhadas'] as String)),
      letrasErradas: List<String>.from(jsonDecode(json['letras_erradas'] as String)),
      estado: EstadoPartida.values.byName(json['estado'] as String),
      dataCriacao: DateTime.parse(json['data_criacao'] as String),
    );
  }

  Map<String, dynamic> toHive() => {
        'id': id,
        'nivel': nivel,
        'acertos_neste_nivel': acertosNesteNivel,
        'erros_consecutivos': errosConsecutivos,
        'pergunta_atual_id': perguntaAtualId,
        'letras_adivinhadas': jsonEncode(letrasAdivinhadas),
        'letras_erradas': jsonEncode(letrasErradas),
        'estado': estado.name,
        'data_criacao': dataCriacao.toIso8601String(),
      };
}
