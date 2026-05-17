import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../utils/constants.dart';
import '../../models/pergunta_model.dart';
import 'hive_service.dart';

class PerguntaLocalDatasource {
  Future<List<PerguntaModel>> obterTodasPerguntas() async {
    await HiveService.garantirInicializado();
    final box = HiveService.perguntas;
    return box.values
        .map((m) => PerguntaModel.fromHive(m))
        .toList();
  }

  Future<PerguntaModel?> obterPerguntaPorId(String id) async {
    await HiveService.garantirInicializado();
    final raw = HiveService.perguntas.get(id);
    if (raw == null) return null;
    return PerguntaModel.fromHive(raw);
  }

  Future<void> salvarPerguntas(List<PerguntaModel> perguntas) async {
    await HiveService.garantirInicializado();
    final box = HiveService.perguntas;
    final entries = {for (final p in perguntas) p.id: p.toHive()};
    await box.putAll(entries);
  }

  Future<void> carregarPacoteEmbarcado() async {
    await HiveService.garantirInicializado();
    final json = await rootBundle.loadString(GameConstants.pathPerguntasEmbarcadas);
    final lista = (jsonDecode(json) as List)
        .cast<Map<String, dynamic>>()
        .map(PerguntaModel.fromJson)
        .toList();
    await salvarPerguntas(lista);
  }

  Future<bool> temPerguntas() async {
    await HiveService.garantirInicializado();
    return HiveService.perguntas.isNotEmpty;
  }
}
