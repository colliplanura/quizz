import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  const GameStarted();
}

class GameLetterGuessed extends GameEvent {
  const GameLetterGuessed(this.letra);

  final String letra;

  @override
  List<Object?> get props => [letra];
}

class GameContinued extends GameEvent {
  const GameContinued();
}

class GameRestarted extends GameEvent {
  const GameRestarted();
}

class GameRestored extends GameEvent {
  const GameRestored();
}
