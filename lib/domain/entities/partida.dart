import 'package:equatable/equatable.dart';

enum EstadoPartida { emAndamento, gameOver, nivelCompleto, aguardando }

class Partida extends Equatable {
  const Partida({
    required this.id,
    required this.nivel,
    required this.acertosNesteNivel,
    required this.errosConsecutivos,
    required this.perguntaAtualId,
    required this.letrasAdivinhadas,
    required this.letrasErradas,
    required this.estado,
    required this.dataCriacao,
  });

  final String id;
  final int nivel;
  final int acertosNesteNivel;
  final int errosConsecutivos;
  final String perguntaAtualId;
  final List<String> letrasAdivinhadas;
  final List<String> letrasErradas;
  final EstadoPartida estado;
  final DateTime dataCriacao;

  Partida copyWith({
    int? nivel,
    int? acertosNesteNivel,
    int? errosConsecutivos,
    String? perguntaAtualId,
    List<String>? letrasAdivinhadas,
    List<String>? letrasErradas,
    EstadoPartida? estado,
  }) {
    return Partida(
      id: id,
      nivel: nivel ?? this.nivel,
      acertosNesteNivel: acertosNesteNivel ?? this.acertosNesteNivel,
      errosConsecutivos: errosConsecutivos ?? this.errosConsecutivos,
      perguntaAtualId: perguntaAtualId ?? this.perguntaAtualId,
      letrasAdivinhadas: letrasAdivinhadas ?? this.letrasAdivinhadas,
      letrasErradas: letrasErradas ?? this.letrasErradas,
      estado: estado ?? this.estado,
      dataCriacao: dataCriacao,
    );
  }

  @override
  List<Object?> get props => [id, nivel, acertosNesteNivel, errosConsecutivos, perguntaAtualId, letrasAdivinhadas, letrasErradas, estado, dataCriacao];
}
