import '../entities/pergunta_catalogo.dart';

/// Repository for PerguntaCatalogo
abstract class CatalogoRepository {
  /// Get all questions from the catalog
  Future<List<PerguntaCatalogo>> obterTodas();

  /// Get a question by ID
  Future<PerguntaCatalogo?> obterPorId(String id);

  /// Get questions by difficulty
  Future<List<PerguntaCatalogo>> obterPorDificuldade(int dificuldade);

  /// Get questions by category
  Future<List<PerguntaCatalogo>> obterPorCategoria(String categoria);

  /// Validate catalog structure and content
  Future<bool> validarCatalogo();

  /// Get difficulty distribution
  Future<Map<int, int>> obterDistribuicaoDificuldade();

  /// Get category distribution
  Future<Map<String, int>> obterDistribuicaoCategoria();

  /// Get total count of questions
  Future<int> obterTotal();
}
