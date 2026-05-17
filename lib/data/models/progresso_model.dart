import '../../domain/entities/progresso.dart';
import '../../utils/constants.dart';

class ProgressoModel extends Progresso {
  const ProgressoModel({
    required super.id,
    required super.nivelAtual,
    required super.pontuacaoTotal,
    required super.trofeusGanhos,
    required super.acertosConsecutivos,
    required super.errosConsecutivos,
    required super.timestampUltimaSincronizacao,
    super.partidaAtivaId,
  });

  factory ProgressoModel.inicial() => ProgressoModel(
        id: GameConstants.idProgressoJogador,
        nivelAtual: GameConstants.nivelInicial,
        pontuacaoTotal: GameConstants.pontuacaoInicial,
        trofeusGanhos: GameConstants.trofeusIniciais,
        acertosConsecutivos: 0,
        errosConsecutivos: 0,
        timestampUltimaSincronizacao: DateTime.fromMillisecondsSinceEpoch(0),
      );

  factory ProgressoModel.fromHive(Map<dynamic, dynamic> map) {
    final json = map.map((k, v) => MapEntry(k.toString(), v));
    return ProgressoModel(
      id: json['id'] as String,
      nivelAtual: json['nivel_atual'] as int,
      pontuacaoTotal: json['pontuacao_total'] as int,
      trofeusGanhos: json['trofeus_ganhos'] as int,
      acertosConsecutivos: json['acertos_consecutivos'] as int,
      errosConsecutivos: json['erros_consecutivos'] as int,
      timestampUltimaSincronizacao: DateTime.parse(json['timestamp_ultima_sincronizacao'] as String),
      partidaAtivaId: json['partida_ativa_id'] as String?,
    );
  }

  Map<String, dynamic> toHive() => {
        'id': id,
        'nivel_atual': nivelAtual,
        'pontuacao_total': pontuacaoTotal,
        'trofeus_ganhos': trofeusGanhos,
        'acertos_consecutivos': acertosConsecutivos,
        'erros_consecutivos': errosConsecutivos,
        'timestamp_ultima_sincronizacao': timestampUltimaSincronizacao.toIso8601String(),
        if (partidaAtivaId != null) 'partida_ativa_id': partidaAtivaId,
      };
}
