import '../../domain/entities/pergunta.dart';

class PerguntaModel extends Pergunta {
  const PerguntaModel({
    required super.id,
    required super.pergunta,
    required super.resposta,
    required super.exibicaoResposta,
    required super.categoria,
    required super.dificuldade,
    required super.contextoHistorico,
    super.dataCriacao,
  });

  factory PerguntaModel.fromJson(Map<String, dynamic> json) {
    final contextoRaw = json['contexto_historico'];
    Map<String, String> contexto;
    if (contextoRaw is Map) {
      contexto = contextoRaw.map((k, v) => MapEntry(k.toString(), v.toString()));
    } else if (contextoRaw is String) {
      // graceful degradation: plain string treated as pt_BR only
      contexto = {'pt_BR': contextoRaw};
    } else {
      contexto = {'pt_BR': ''};
    }

    return PerguntaModel(
      id: json['id'] as String,
      pergunta: json['pergunta'] as String,
      resposta: json['resposta'] as String,
      exibicaoResposta: json['exibicao_resposta'] as String,
      categoria: json['categoria'] as String,
      dificuldade: json['dificuldade'] as int,
      contextoHistorico: contexto,
      dataCriacao: json['data_criacao'] != null
          ? DateTime.tryParse(json['data_criacao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pergunta': pergunta,
        'resposta': resposta,
        'exibicao_resposta': exibicaoResposta,
        'categoria': categoria,
        'dificuldade': dificuldade,
        'contexto_historico': contextoHistorico,
        if (dataCriacao != null) 'data_criacao': dataCriacao!.toIso8601String(),
      };

  Map<String, dynamic> toHive() => toJson();

  factory PerguntaModel.fromHive(Map<dynamic, dynamic> map) {
    final json = map.map((k, v) => MapEntry(k.toString(), v));
    final contextoRaw = json['contexto_historico'];
    Map<String, String> contexto;
    if (contextoRaw is Map) {
      contexto = contextoRaw.map((k, v) => MapEntry(k.toString(), v.toString()));
    } else {
      contexto = {'pt_BR': contextoRaw?.toString() ?? ''};
    }
    return PerguntaModel(
      id: json['id'] as String,
      pergunta: json['pergunta'] as String,
      resposta: json['resposta'] as String,
      exibicaoResposta: json['exibicao_resposta'] as String,
      categoria: json['categoria'] as String,
      dificuldade: json['dificuldade'] as int,
      contextoHistorico: contexto,
      dataCriacao: json['data_criacao'] != null
          ? DateTime.tryParse(json['data_criacao'] as String)
          : null,
    );
  }
}
