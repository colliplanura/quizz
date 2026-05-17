import 'package:hive_flutter/hive_flutter.dart';

import '../../../utils/constants.dart';

class HiveService {
  static Box<Map>? _perguntasBox;
  static Box<Map>? _progressoBox;
  static Box<Map>? _partidaBox;
  static Box<Map>? _trofeusBox;
  static Box<Map>? _configBox;
  static bool _inicializado = false;

  static Future<void> inicializar() async {
    if (_inicializado) return;
    _perguntasBox = await Hive.openBox<Map>(GameConstants.hiveBoxPerguntas);
    _progressoBox = await Hive.openBox<Map>(GameConstants.hiveBoxProgresso);
    _partidaBox = await Hive.openBox<Map>(GameConstants.hiveBoxPartida);
    _trofeusBox = await Hive.openBox<Map>(GameConstants.hiveBoxTrofeus);
    _configBox = await Hive.openBox<Map>(GameConstants.hiveBoxConfig);
    _inicializado = true;
  }

  static Future<void> garantirInicializado() => inicializar();

  static Box<Map> get perguntas {
    assert(_perguntasBox != null && _perguntasBox!.isOpen, 'HiveService não foi inicializado');
    return _perguntasBox!;
  }

  static Box<Map> get progresso {
    assert(_progressoBox != null && _progressoBox!.isOpen, 'HiveService não foi inicializado');
    return _progressoBox!;
  }

  static Box<Map> get partida {
    assert(_partidaBox != null && _partidaBox!.isOpen, 'HiveService não foi inicializado');
    return _partidaBox!;
  }

  static Box<Map> get trofeus {
    assert(_trofeusBox != null && _trofeusBox!.isOpen, 'HiveService não foi inicializado');
    return _trofeusBox!;
  }

  static Box<Map> get config {
    assert(_configBox != null && _configBox!.isOpen, 'HiveService não foi inicializado');
    return _configBox!;
  }

  static Future<void> fecharTudo() async {
    await Hive.close();
  }
}
