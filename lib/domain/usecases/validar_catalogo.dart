import '../repositories/catalogo_repository.dart';

/// UseCase: Validate catalog structure and content
class ValidarCatalogoUseCase {
  final CatalogoRepository _repository;

  ValidarCatalogoUseCase(this._repository);

  /// Validate the entire catalog
  Future<ValidacaoCatalogo> call() async {
    try {
      final isValid = await _repository.validarCatalogo();

      if (!isValid) {
        return ValidacaoCatalogo(
          valido: false,
          mensagem: 'Catálogo não passou na validação',
        );
      }

      final total = await _repository.obterTotal();
      final distribuicaoDificuldade = await _repository
          .obterDistribuicaoDificuldade();
      final distribuicaoCategoria = await _repository
          .obterDistribuicaoCategoria();

      return ValidacaoCatalogo(
        valido: true,
        mensagem: 'Catálogo validado com sucesso',
        totalPerguntas: total,
        totalCategorias: distribuicaoCategoria.length,
        totalDificuldades: distribuicaoDificuldade.length,
        distribuicaoDificuldade: distribuicaoDificuldade,
        distribuicaoCategoria: distribuicaoCategoria,
      );
    } catch (e) {
      return ValidacaoCatalogo(
        valido: false,
        mensagem: 'Erro ao validar catálogo: $e',
      );
    }
  }
}

/// Result of catalog validation
class ValidacaoCatalogo {
  final bool valido;
  final String mensagem;
  final int? totalPerguntas;
  final int? totalCategorias;
  final int? totalDificuldades;
  final Map<int, int>? distribuicaoDificuldade;
  final Map<String, int>? distribuicaoCategoria;

  ValidacaoCatalogo({
    required this.valido,
    required this.mensagem,
    this.totalPerguntas,
    this.totalCategorias,
    this.totalDificuldades,
    this.distribuicaoDificuldade,
    this.distribuicaoCategoria,
  });

  @override
  String toString() =>
      '''
ValidacaoCatalogo(
  valido: $valido,
  mensagem: $mensagem,
  totalPerguntas: $totalPerguntas,
  totalCategorias: $totalCategorias,
  totalDificuldades: $totalDificuldades,
  distribuicaoDificuldade: $distribuicaoDificuldade,
  distribuicaoCategoria: $distribuicaoCategoria,
)
''';
}
