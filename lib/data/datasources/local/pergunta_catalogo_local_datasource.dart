import '../../../domain/entities/pergunta_catalogo.dart';

/// Local data source for PerguntaCatalogo
abstract class PerguntaCatalogoLocalDataSource {
  Future<void> salvarPerguntas(List<PerguntaCatalogo> perguntas);
  Future<List<PerguntaCatalogo>> obterTodasPerguntas();
  Future<PerguntaCatalogo?> obterPergunta(String id);
  Future<void> deletarTodas();
  Future<int> contarPerguntas();
}

/// Implementation using Hive
class PerguntaCatalogoLocalDataSourceImpl
    implements PerguntaCatalogoLocalDataSource {
  final String boxName;

  PerguntaCatalogoLocalDataSourceImpl({required this.boxName});

  @override
  Future<void> salvarPerguntas(List<PerguntaCatalogo> perguntas) async {
    // Implementação: salvar em Hive box
    throw UnimplementedError('T011 - to be implemented');
  }

  @override
  Future<List<PerguntaCatalogo>> obterTodasPerguntas() async {
    // Implementação: obter todas do Hive box
    throw UnimplementedError('T011 - to be implemented');
  }

  @override
  Future<PerguntaCatalogo?> obterPergunta(String id) async {
    // Implementação: obter por ID
    throw UnimplementedError('T011 - to be implemented');
  }

  @override
  Future<void> deletarTodas() async {
    // Implementação: limpar box
    throw UnimplementedError('T011 - to be implemented');
  }

  @override
  Future<int> contarPerguntas() async {
    // Implementação: contar itens
    throw UnimplementedError('T011 - to be implemented');
  }
}
