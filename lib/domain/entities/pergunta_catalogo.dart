import 'package:equatable/equatable.dart';

/// PerguntaCatalogo - Pergunta do banco inicial/sincronizado
class PerguntaCatalogo extends Equatable {
  final String id;
  final String enunciado;
  final String respostaNormalizada;
  final String respostaExibicao;
  final String categoria;
  final int dificuldade; // 1-10
  final Map<String, String> contexto; // idioma -> texto
  final String origem; // embarcado | sincronizado
  final DateTime? criadoEm;

  const PerguntaCatalogo({
    required this.id,
    required this.enunciado,
    required this.respostaNormalizada,
    required this.respostaExibicao,
    required this.categoria,
    required this.dificuldade,
    required this.contexto,
    this.origem = 'embarcado',
    this.criadoEm,
  });

  @override
  List<Object?> get props => [
    id,
    enunciado,
    respostaNormalizada,
    respostaExibicao,
    categoria,
    dificuldade,
    contexto,
    origem,
    criadoEm,
  ];
}
