import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/listar_catalogo.dart';
import '../../domain/usecases/validar_catalogo.dart';
import 'catalogo_event.dart';
import 'catalogo_state.dart';

/// BLoC for managing catalog operations
class CatalogoBLoC extends Bloc<CatalogoEvent, CatalogoState> {
  final ListarCatalogoUseCase _listarCatalogo;
  final ValidarCatalogoUseCase _validarCatalogo;

  CatalogoBLoC({
    required ListarCatalogoUseCase listarCatalogo,
    required ValidarCatalogoUseCase validarCatalogo,
  }) : _listarCatalogo = listarCatalogo,
       _validarCatalogo = validarCatalogo,
       super(const CatalogoInicial()) {
    on<CarregarCatalogoEvent>(_onCarregarCatalogo);
    on<ValidarCatalogoEvent>(_onValidarCatalogo);
    on<FiltrarPorDificuldadeEvent>(_onFiltrarPorDificuldade);
    on<FiltrarPorCategoriaEvent>(_onFiltrarPorCategoria);
  }

  /// Load catalog from repository
  Future<void> _onCarregarCatalogo(
    CarregarCatalogoEvent event,
    Emitter<CatalogoState> emit,
  ) async {
    try {
      emit(const CatalogoCarregando());

      final perguntas = await _listarCatalogo();
      final distribuicaoDificuldade = await _listarCatalogo
          .obterDistribuicaoDificuldade();
      final distribuicaoCategoria = await _listarCatalogo
          .obterDistribuicaoCategoria();
      final total = await _listarCatalogo.obterTotal();

      emit(
        CatalogoCarregado(
          perguntas: perguntas,
          total: total,
          distribuicaoDificuldade: distribuicaoDificuldade,
          distribuicaoCategoria: distribuicaoCategoria,
        ),
      );
    } catch (e) {
      emit(CatalogoErro('Erro ao carregar catálogo: $e'));
    }
  }

  /// Validate catalog
  Future<void> _onValidarCatalogo(
    ValidarCatalogoEvent event,
    Emitter<CatalogoState> emit,
  ) async {
    try {
      emit(const CatalogoCarregando());

      final validacao = await _validarCatalogo();

      if (validacao.valido) {
        emit(CatalogoValidado(validacao));
      } else {
        emit(CatalogoErro(validacao.mensagem));
      }
    } catch (e) {
      emit(CatalogoErro('Erro ao validar catálogo: $e'));
    }
  }

  /// Filter by difficulty
  Future<void> _onFiltrarPorDificuldade(
    FiltrarPorDificuldadeEvent event,
    Emitter<CatalogoState> emit,
  ) async {
    try {
      final perguntas = await _listarCatalogo.obterPorDificuldade(
        event.dificuldade,
      );

      emit(
        CatalogoPorDificuldade(
          perguntas: perguntas,
          dificuldade: event.dificuldade,
        ),
      );
    } catch (e) {
      emit(CatalogoErro('Erro ao filtrar por dificuldade: $e'));
    }
  }

  /// Filter by category
  Future<void> _onFiltrarPorCategoria(
    FiltrarPorCategoriaEvent event,
    Emitter<CatalogoState> emit,
  ) async {
    try {
      final perguntas = await _listarCatalogo.obterPorCategoria(
        event.categoria,
      );

      emit(
        CatalogoPorCategoria(perguntas: perguntas, categoria: event.categoria),
      );
    } catch (e) {
      emit(CatalogoErro('Erro ao filtrar por categoria: $e'));
    }
  }
}
