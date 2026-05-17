import 'package:equatable/equatable.dart';
import '../../domain/entities/partida.dart';
import '../../domain/entities/pergunta.dart';
import '../../domain/entities/progresso.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameRunning extends GameState {
  const GameRunning({
    required this.partida,
    required this.progresso,
    required this.pergunta,
  });

  final Partida partida;
  final Progresso progresso;
  final Pergunta pergunta;

  @override
  List<Object?> get props => [partida, progresso, pergunta];
}

class GameLevelUp extends GameState {
  const GameLevelUp({
    required this.partida,
    required this.progresso,
    required this.novoNivel,
  });

  final Partida partida;
  final Progresso progresso;
  final int novoNivel;

  @override
  List<Object?> get props => [partida, progresso, novoNivel];
}

class GameOver extends GameState {
  const GameOver({
    required this.partida,
    required this.progresso,
    required this.podeContinuar,
  });

  final Partida partida;
  final Progresso progresso;
  final bool podeContinuar;

  @override
  List<Object?> get props => [partida, progresso, podeContinuar];
}

class GameError extends GameState {
  const GameError(this.mensagem);

  final String mensagem;

  @override
  List<Object?> get props => [mensagem];
}
