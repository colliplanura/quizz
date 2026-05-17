import '../../domain/entities/pergunta.dart';
import '../../domain/repositories/pergunta_repository.dart';
import '../datasources/local/pergunta_local_datasource.dart';
import '../models/pergunta_model.dart';

class PerguntaRepositoryImpl implements PerguntaRepository {
  PerguntaRepositoryImpl(this._local);

  final PerguntaLocalDatasource _local;

  @override
  Future<List<Pergunta>> obterTodasPerguntas() => _local.obterTodasPerguntas();

  @override
  Future<Pergunta?> obterPerguntaPorId(String id) => _local.obterPerguntaPorId(id);

  @override
  Future<List<Pergunta>> obterPerguntasPorDificuldade(int dificuldade) async {
    final todas = await _local.obterTodasPerguntas();
    return todas.where((p) => p.dificuldade == dificuldade).toList();
  }

  @override
  Future<void> salvarPerguntas(List<Pergunta> perguntas) async {
    final models = perguntas.map((p) => PerguntaModel(
          id: p.id,
          pergunta: p.pergunta,
          resposta: p.resposta,
          exibicaoResposta: p.exibicaoResposta,
          categoria: p.categoria,
          dificuldade: p.dificuldade,
          contextoHistorico: p.contextoHistorico,
          dataCriacao: p.dataCriacao,
        )).toList();
    await _local.salvarPerguntas(models);
  }

  @override
  Future<void> carregarPacoteEmbarcado() => _local.carregarPacoteEmbarcado();

  @override
  Future<bool> temPerguntas() => _local.temPerguntas();
}
