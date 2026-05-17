import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class LoggingService {
  static const String _appTag = 'QuizVerse';

  static void debug(String mensagem, {String? contexto}) {
    _log(LogLevel.debug, mensagem, contexto: contexto);
  }

  static void info(String mensagem, {String? contexto}) {
    _log(LogLevel.info, mensagem, contexto: contexto);
  }

  static void warning(String mensagem, {String? contexto}) {
    _log(LogLevel.warning, mensagem, contexto: contexto);
  }

  static void error(String mensagem, {Object? erro, StackTrace? stackTrace, String? contexto}) {
    _log(LogLevel.error, mensagem, contexto: contexto);
    if (kDebugMode && erro != null) {
      debugPrint('[$_appTag][ERROR] Erro: $erro');
      if (stackTrace != null) {
        debugPrint('[$_appTag][ERROR] StackTrace: $stackTrace');
      }
    }
  }

  static void _log(LogLevel nivel, String mensagem, {String? contexto}) {
    if (!kDebugMode) return;
    final tag = contexto != null ? '$_appTag/$contexto' : _appTag;
    final prefixo = switch (nivel) {
      LogLevel.debug   => 'DEBUG',
      LogLevel.info    => 'INFO ',
      LogLevel.warning => 'WARN ',
      LogLevel.error   => 'ERROR',
    };
    debugPrint('[$tag][$prefixo] $mensagem');
  }
}
