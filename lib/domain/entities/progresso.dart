import 'package:equatable/equatable.dart';

class Progresso extends Equatable {
  const Progresso({
    required this.id,
    required this.nivelAtual,
    required this.pontuacaoTotal,
    required this.trofeusGanhos,
    required this.acertosConsecutivos,
    required this.errosConsecutivos,
    required this.timestampUltimaSincronizacao,
    this.partidaAtivaId,
  });

  final String id;
  final int nivelAtual;
  final int pontuacaoTotal;
  final int trofeusGanhos;
  final int acertosConsecutivos;
  final int errosConsecutivos;
  final DateTime timestampUltimaSincronizacao;
  final String? partidaAtivaId;

  Progresso copyWith({
    int? nivelAtual,
    int? pontuacaoTotal,
    int? trofeusGanhos,
    int? acertosConsecutivos,
    int? errosConsecutivos,
    DateTime? timestampUltimaSincronizacao,
    String? partidaAtivaId,
    bool clearPartidaAtiva = false,
  }) {
    return Progresso(
      id: id,
      nivelAtual: nivelAtual ?? this.nivelAtual,
      pontuacaoTotal: pontuacaoTotal ?? this.pontuacaoTotal,
      trofeusGanhos: trofeusGanhos ?? this.trofeusGanhos,
      acertosConsecutivos: acertosConsecutivos ?? this.acertosConsecutivos,
      errosConsecutivos: errosConsecutivos ?? this.errosConsecutivos,
      timestampUltimaSincronizacao: timestampUltimaSincronizacao ?? this.timestampUltimaSincronizacao,
      partidaAtivaId: clearPartidaAtiva ? null : (partidaAtivaId ?? this.partidaAtivaId),
    );
  }

  @override
  List<Object?> get props => [id, nivelAtual, pontuacaoTotal, trofeusGanhos, acertosConsecutivos, errosConsecutivos, timestampUltimaSincronizacao, partidaAtivaId];
}
