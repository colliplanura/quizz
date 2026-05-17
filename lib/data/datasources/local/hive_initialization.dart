import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/pergunta_catalogo.dart';
import '../../../domain/entities/historico_pergunta_respondida.dart';
import '../../../domain/entities/configuracao_partida.dart';
import '../../../domain/entities/perfil_distribuicao_dificuldade.dart';

/// Inicializa boxes Hive para persistência local
class HiveInitialization {
  static const String perguntaCatalogoBoxName = 'pergunta_catalogo_box';
  static const String historicoPerguntaBoxName = 'historico_pergunta_box';
  static const String configuracaoPartidaBoxName = 'configuracao_partida_box';
  static const String perfilDistribuicaoBoxName = 'perfil_distribuicao_box';

  static Future<void> initializeHive() async {
    await Hive.initFlutter();

    // Registrar adapters
    _registerAdapters();

    // Abrir boxes
    await Hive.openBox<PerguntaCatalogo>(perguntaCatalogoBoxName);
    await Hive.openBox<HistoricoPerguntaRespondida>(historicoPerguntaBoxName);
    await Hive.openBox<ConfiguracaoPartida>(configuracaoPartidaBoxName);
    await Hive.openBox<PerfilDistribuicaoDificuldade>(
      perfilDistribuicaoBoxName,
    );
  }

  static void _registerAdapters() {
    // Adapters will be registered when created in T010
    // Placeholder for adapter registration
  }

  static void closeHive() {
    Hive.close();
  }
}
