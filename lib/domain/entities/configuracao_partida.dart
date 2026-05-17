import 'package:equatable/equatable.dart';

/// ConfiguracaoPartida - Parâmetros globais da sessão de jogo
/// Define limites e regras que aplicam em todo o jogo
class ConfiguracaoPartida extends Equatable {
  final int maxErrosConsecutivos;
  final int janelaAntiRepeticaoHoras;
  final String versaoRegras;

  const ConfiguracaoPartida({
    required this.maxErrosConsecutivos,
    required this.janelaAntiRepeticaoHoras,
    required this.versaoRegras,
  });

  @override
  List<Object?> get props => [
    maxErrosConsecutivos,
    janelaAntiRepeticaoHoras,
    versaoRegras,
  ];
}
