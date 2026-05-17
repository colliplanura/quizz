import 'package:equatable/equatable.dart';

class Pergunta extends Equatable {
  const Pergunta({
    required this.id,
    required this.pergunta,
    required this.resposta,
    required this.exibicaoResposta,
    required this.categoria,
    required this.dificuldade,
    required this.contextoHistorico,
    this.dataCriacao,
  });

  final String id;
  final String pergunta;
  final String resposta;
  final String exibicaoResposta;
  final String categoria;
  final int dificuldade;
  final Map<String, String> contextoHistorico;
  final DateTime? dataCriacao;

  String contextoParaIdioma(String codigoIdioma) {
    return contextoHistorico[codigoIdioma] ??
        contextoHistorico['pt_BR'] ??
        '';
  }

  @override
  List<Object?> get props => [id, pergunta, resposta, exibicaoResposta, categoria, dificuldade, contextoHistorico, dataCriacao];
}
