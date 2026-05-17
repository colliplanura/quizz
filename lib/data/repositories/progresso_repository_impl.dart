import '../../domain/entities/partida.dart';
import '../../domain/entities/progresso.dart';
import '../../domain/entities/trofeu.dart';
import '../../domain/repositories/progresso_repository.dart';
import '../datasources/local/progresso_local_datasource.dart';
import '../models/partida_model.dart';
import '../models/progresso_model.dart';
import '../models/trofeu_model.dart';

class ProgressoRepositoryImpl implements ProgressoRepository {
  ProgressoRepositoryImpl(this._local);

  final ProgressoLocalDatasource _local;

  @override
  Future<Progresso?> obterProgresso() => _local.obterProgresso();

  @override
  Future<void> salvarProgresso(Progresso progresso) async {
    final model = progresso is ProgressoModel
        ? progresso
        : ProgressoModel(
            id: progresso.id,
            nivelAtual: progresso.nivelAtual,
            pontuacaoTotal: progresso.pontuacaoTotal,
            trofeusGanhos: progresso.trofeusGanhos,
            acertosConsecutivos: progresso.acertosConsecutivos,
            errosConsecutivos: progresso.errosConsecutivos,
            timestampUltimaSincronizacao: progresso.timestampUltimaSincronizacao,
            partidaAtivaId: progresso.partidaAtivaId,
          );
    await _local.salvarProgresso(model);
  }

  @override
  Future<Partida?> obterPartidaAtiva() => _local.obterPartidaAtiva();

  @override
  Future<void> salvarPartida(Partida partida) async {
    final model = partida is PartidaModel
        ? partida
        : PartidaModel(
            id: partida.id,
            nivel: partida.nivel,
            acertosNesteNivel: partida.acertosNesteNivel,
            errosConsecutivos: partida.errosConsecutivos,
            perguntaAtualId: partida.perguntaAtualId,
            letrasAdivinhadas: partida.letrasAdivinhadas,
            letrasErradas: partida.letrasErradas,
            estado: partida.estado,
            dataCriacao: partida.dataCriacao,
          );
    await _local.salvarPartida(model);
  }

  @override
  Future<void> limparPartidaAtiva() => _local.limparPartidaAtiva();

  @override
  Future<List<Trofeu>> obterTrofeus() => _local.obterTrofeus();

  @override
  Future<void> salvarTrofeu(Trofeu trofeu) async {
    final model = trofeu is TrofeuModel
        ? trofeu
        : TrofeuModel(
            id: trofeu.id,
            tipo: trofeu.tipo,
            nome: trofeu.nome,
            descricao: trofeu.descricao,
            dataGanho: trofeu.dataGanho,
            iconeUrl: trofeu.iconeUrl,
            pontosBonus: trofeu.pontosBonus,
          );
    await _local.salvarTrofeu(model);
  }
}
