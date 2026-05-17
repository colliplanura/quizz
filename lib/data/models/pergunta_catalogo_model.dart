import '../../domain/entities/pergunta_catalogo.dart';

/// Model for PerguntaCatalogo with JSON serialization
class PerguntaCatalogoModel extends PerguntaCatalogo {
  const PerguntaCatalogoModel({
    required super.id,
    required super.enunciado,
    required super.respostaNormalizada,
    required super.respostaExibicao,
    required super.categoria,
    required super.dificuldade,
    required super.contexto,
    super.origem = 'embarcado',
    super.criadoEm,
  });

  /// Create from JSON (perguntas_inicial.json format)
  factory PerguntaCatalogoModel.fromJson(Map<String, dynamic> json) {
    final contextoRaw = json['contexto_historico'];
    Map<String, String> contexto;
    if (contextoRaw is Map) {
      contexto = contextoRaw.map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );
    } else if (contextoRaw is String) {
      contexto = {'pt_BR': contextoRaw};
    } else {
      contexto = {'pt_BR': ''};
    }

    return PerguntaCatalogoModel(
      id: json['id'] as String,
      enunciado: json['pergunta'] as String? ?? json['enunciado'] as String,
      respostaNormalizada: json['resposta'] as String,
      respostaExibicao:
          json['exibicao_resposta'] as String? ?? json['resposta'] as String,
      categoria: json['categoria'] as String,
      dificuldade: json['dificuldade'] as int,
      contexto: contexto,
      origem: json['origem'] as String? ?? 'embarcado',
      criadoEm: json['data_criacao'] != null
          ? DateTime.tryParse(json['data_criacao'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'pergunta': enunciado,
    'resposta': respostaNormalizada,
    'exibicao_resposta': respostaExibicao,
    'categoria': categoria,
    'dificuldade': dificuldade,
    'contexto_historico': contexto,
    'origem': origem,
    if (criadoEm != null) 'data_criacao': criadoEm!.toIso8601String(),
  };

  /// Convert to Hive format
  Map<String, dynamic> toHive() => toJson();

  /// Create from Hive
  factory PerguntaCatalogoModel.fromHive(Map<dynamic, dynamic> map) {
    final json = map.map((k, v) => MapEntry(k.toString(), v));
    final contextoRaw = json['contexto_historico'];
    Map<String, String> contexto;
    if (contextoRaw is Map) {
      contexto = contextoRaw.map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );
    } else {
      contexto = {'pt_BR': contextoRaw?.toString() ?? ''};
    }

    return PerguntaCatalogoModel(
      id: json['id'] as String,
      enunciado: json['pergunta'] as String? ?? json['enunciado'] as String,
      respostaNormalizada: json['resposta'] as String,
      respostaExibicao:
          json['exibicao_resposta'] as String? ?? json['resposta'] as String,
      categoria: json['categoria'] as String,
      dificuldade: json['dificuldade'] as int,
      contexto: contexto,
      origem: json['origem'] as String? ?? 'embarcado',
      criadoEm: json['data_criacao'] != null
          ? DateTime.tryParse(json['data_criacao'] as String)
          : null,
    );
  }
}
