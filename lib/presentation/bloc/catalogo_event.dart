import 'package:equatable/equatable.dart';

abstract class CatalogoEvent extends Equatable {
  const CatalogoEvent();

  @override
  List<Object?> get props => [];
}

class CarregarCatalogoEvent extends CatalogoEvent {
  const CarregarCatalogoEvent();
}

class ValidarCatalogoEvent extends CatalogoEvent {
  const ValidarCatalogoEvent();
}

class FiltrarPorDificuldadeEvent extends CatalogoEvent {
  const FiltrarPorDificuldadeEvent(this.dificuldade);

  final int dificuldade;

  @override
  List<Object?> get props => [dificuldade];
}

class FiltrarPorCategoriaEvent extends CatalogoEvent {
  const FiltrarPorCategoriaEvent(this.categoria);

  final String categoria;

  @override
  List<Object?> get props => [categoria];
}
