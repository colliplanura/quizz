import '../../domain/entities/pergunta_catalogo.dart';
import '../../domain/repositories/catalogo_repository.dart';
import '../datasources/local/asset_catalogo_local_datasource.dart';

/// Implementation of CatalogoRepository
class CatalogoRepositoryImpl implements CatalogoRepository {
  final AssetCatalogoLocalDataSource _assetDataSource;

  CatalogoRepositoryImpl(this._assetDataSource);

  @override
  Future<List<PerguntaCatalogo>> obterTodas() async {
    return await _assetDataSource.obterCatalogoPrincipal();
  }

  @override
  Future<PerguntaCatalogo?> obterPorId(String id) async {
    final todas = await _assetDataSource.obterCatalogoPrincipal();
    try {
      return todas.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<PerguntaCatalogo>> obterPorDificuldade(int dificuldade) async {
    final todas = await _assetDataSource.obterCatalogoPrincipal();
    return todas.where((p) => p.dificuldade == dificuldade).toList();
  }

  @override
  Future<List<PerguntaCatalogo>> obterPorCategoria(String categoria) async {
    final todas = await _assetDataSource.obterCatalogoPrincipal();
    return todas.where((p) => p.categoria == categoria).toList();
  }

  @override
  Future<bool> validarCatalogo() async {
    try {
      await _assetDataSource.obterCatalogoValidado();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<int, int>> obterDistribuicaoDificuldade() async {
    return await _assetDataSource.obterDistribuicaoDificuldade();
  }

  @override
  Future<Map<String, int>> obterDistribuicaoCategoria() async {
    return await _assetDataSource.obterDistribuicaoCategoria();
  }

  @override
  Future<int> obterTotal() async {
    return await _assetDataSource.obterTotal();
  }
}
