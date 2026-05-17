import 'package:equatable/equatable.dart';
import '../../domain/entities/pergunta_catalogo.dart';
import '../../domain/usecases/validar_catalogo.dart';

abstract class CatalogoState extends Equatable {
  const CatalogoState();

  @override
  List<Object?> get props => [];
}

class CatalogoInicial extends CatalogoState {
  const CatalogoInicial();
}

class CatalogoCarregando extends CatalogoState {
  const CatalogoCarregando();
}

class CatalogoCarregado extends CatalogoState {
  final List<PerguntaCatalogo> perguntas;
  final int total;
  final Map<int, int> distribuicaoDificuldade;
  final Map<String, int> distribuicaoCategoria;

  const CatalogoCarregado({
    required this.perguntas,
    required this.total,
    required this.distribuicaoDificuldade,
    required this.distribuicaoCategoria,
  });

  @override
  List<Object?> get props => [
    perguntas,
    total,
    distribuicaoDificuldade,
    distribuicaoCategoria,
  ];
}

class CatalogoValidado extends CatalogoState {
  final ValidacaoCatalogo validacao;

  const CatalogoValidado(this.validacao);

  @override
  List<Object?> get props => [validacao];
}

class CatalogoErro extends CatalogoState {
  final String mensagem;

  const CatalogoErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}

class CatalogoPorDificuldade extends CatalogoState {
  final List<PerguntaCatalogo> perguntas;
  final int dificuldade;

  const CatalogoPorDificuldade({
    required this.perguntas,
    required this.dificuldade,
  });

  @override
  List<Object?> get props => [perguntas, dificuldade];
}

class CatalogoPorCategoria extends CatalogoState {
  final List<PerguntaCatalogo> perguntas;
  final String categoria;

  const CatalogoPorCategoria({
    required this.perguntas,
    required this.categoria,
  });

  @override
  List<Object?> get props => [perguntas, categoria];
}
