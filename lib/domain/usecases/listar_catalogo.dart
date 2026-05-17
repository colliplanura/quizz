import '../entities/pergunta_catalogo.dart';
import '../repositories/catalogo_repository.dart';

/// UseCase: List all questions from the catalog
class ListarCatalogoUseCase {
  final CatalogoRepository _repository;

  ListarCatalogoUseCase(this._repository);

  Future<List<PerguntaCatalogo>> call() async {
    return await _repository.obterTodas();
  }

  /// List by difficulty
  Future<List<PerguntaCatalogo>> obterPorDificuldade(int dificuldade) async {
    return await _repository.obterPorDificuldade(dificuldade);
  }

  /// List by category
  Future<List<PerguntaCatalogo>> obterPorCategoria(String categoria) async {
    return await _repository.obterPorCategoria(categoria);
  }

  /// Get total count
  Future<int> obterTotal() async {
    return await _repository.obterTotal();
  }

  /// Get difficulty distribution
  Future<Map<int, int>> obterDistribuicaoDificuldade() async {
    return await _repository.obterDistribuicaoDificuldade();
  }

  /// Get category distribution
  Future<Map<String, int>> obterDistribuicaoCategoria() async {
    return await _repository.obterDistribuicaoCategoria();
  }
}
