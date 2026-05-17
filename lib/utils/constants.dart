class GameConstants {
  GameConstants._();

  static const int acertosPorNivel = 10;
  static const int maxErrosConsecutivos = 3;
  static const int nivelInicial = 1;
  static const int pontuacaoInicial = 0;
  static const int trofeusIniciais = 1;
  static const int custoTrofeuContinuar = 1;
  static const String idProgressoJogador = 'player_progress';
  static const Duration intervaloSync = Duration(hours: 24);
  static const int maxContextoHistoricoChars = 120;
  static const String urlPerguntasGithub =
      'https://raw.githubusercontent.com/colliplanura/quizz/main/perguntas.json';
  static const String pathPerguntasEmbarcadas = 'assets/data/perguntas_inicial.json';
  static const String hiveBoxPerguntas = 'perguntas';
  static const String hiveBoxProgresso = 'progresso';
  static const String hiveBoxPartida = 'partida';
  static const String hiveBoxTrofeus = 'trofeus';
  static const String hiveBoxConfig = 'config_idioma';
}
