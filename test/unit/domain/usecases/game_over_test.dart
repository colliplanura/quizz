import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/partida.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Regras de Game Over (3 erros consecutivos)', () {
    bool errosTriggerGameOver(int erros) =>
      erros >= GameConstants.maxErrosConsecutivos;

    Partida partidaComErros(int erros) => Partida(
          id: 'test-id',
          nivel: 1,
          acertosNesteNivel: 0,
          errosConsecutivos: erros,
          perguntaAtualId: 'p1',
          letrasAdivinhadas: const [],
          letrasErradas: const [],
        estado: errosTriggerGameOver(erros)
              ? EstadoPartida.gameOver
              : EstadoPartida.emAndamento,
          dataCriacao: DateTime(2024),
        );

    test('máximo de erros consecutivos é 3', () {
      expect(GameConstants.maxErrosConsecutivos, equals(3));
    });

    test('com 2 erros, partida continua em andamento', () {
      final partida = partidaComErros(2);
      expect(partida.estado, equals(EstadoPartida.emAndamento));
    });

    test('com 3 erros consecutivos, estado é gameOver', () {
      final partida = partidaComErros(3);
      expect(partida.estado, equals(EstadoPartida.gameOver));
    });

    test('com mais de 3 erros, estado é gameOver', () {
      final partida = partidaComErros(5);
      expect(partida.estado, equals(EstadoPartida.gameOver));
    });

    test('erros consecutivos resetam ao acertar', () {
      final partida = Partida(
        id: 'test-id',
        nivel: 1,
        acertosNesteNivel: 1,
        errosConsecutivos: 0, // resetado
        perguntaAtualId: 'p1',
        letrasAdivinhadas: const [],
        letrasErradas: const [],
        estado: EstadoPartida.emAndamento,
        dataCriacao: DateTime(2024),
      );
      expect(partida.errosConsecutivos, equals(0));
    });
  });
}
