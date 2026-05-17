import 'package:equatable/equatable.dart';

/// HistoricoPerguntaRespondida - Registro de pergunta respondida para anti-repetição
class HistoricoPerguntaRespondida extends Equatable {
  final String perguntaId;
  final DateTime respondidaEm; // Wall-clock time
  final String jogadorId; // Local ou chave fixa de progresso

  const HistoricoPerguntaRespondida({
    required this.perguntaId,
    required this.respondidaEm,
    required this.jogadorId,
  });

  @override
  List<Object?> get props => [perguntaId, respondidaEm, jogadorId];
}
