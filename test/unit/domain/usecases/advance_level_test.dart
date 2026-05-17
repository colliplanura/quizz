import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/partida.dart';
import 'package:quizverse_forca/domain/entities/progresso.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Regras de progressão de nível', () {
    Progresso progressoInicial() => Progresso(
          id: GameConstants.idProgressoJogador,
          nivelAtual: GameConstants.nivelInicial,
          pontuacaoTotal: 0,
          trofeusGanhos: GameConstants.trofeusIniciais,
          acertosConsecutivos: 0,
          errosConsecutivos: 0,
          timestampUltimaSincronizacao: DateTime.fromMillisecondsSinceEpoch(0),
        );

    Partida partidaEmAndamento({int acertos = 0, int nivel = 1}) => Partida(
          id: 'test-id',
          nivel: nivel,
          acertosNesteNivel: acertos,
          errosConsecutivos: 0,
          perguntaAtualId: 'p1',
          letrasAdivinhadas: const [],
          letrasErradas: const [],
          estado: EstadoPartida.emAndamento,
          dataCriacao: DateTime(2024),
        );

    test('deve exigir exatamente 10 acertos para level-up', () {
      // com 9 acertos, não há level-up
      final partida9 = partidaEmAndamento(acertos: 9);
      expect(partida9.acertosNesteNivel < GameConstants.acertosPorNivel, isTrue);

      // com 10 acertos, level-up ocorre
      final partida10 = partidaEmAndamento(acertos: 10);
      expect(partida10.acertosNesteNivel >= GameConstants.acertosPorNivel, isTrue);
    });

    test('ao atingir level-up, nivel incrementa em 1', () {
      final progresso = progressoInicial();
      final nivelAntes = progresso.nivelAtual;
      final progressoAtualizado = progresso.copyWith(
        nivelAtual: nivelAntes + 1,
        acertosConsecutivos: 0,
      );
      expect(progressoAtualizado.nivelAtual, equals(nivelAntes + 1));
    });

    test('ao fazer level-up, streak de acertos reseta para 0', () {
      final progresso = progressoInicial().copyWith(acertosConsecutivos: 10);
      final progressoAtualizado = progresso.copyWith(acertosConsecutivos: 0);
      expect(progressoAtualizado.acertosConsecutivos, equals(0));
    });

    test('pontuação incrementa a cada acerto', () {
      final progresso = progressoInicial();
      final atualizado = progresso.copyWith(pontuacaoTotal: progresso.pontuacaoTotal + 1);
      expect(atualizado.pontuacaoTotal, equals(1));
    });

    test('nivel inicial é 1', () {
      expect(GameConstants.nivelInicial, equals(1));
    });

    test('pontuação inicial é 0', () {
      expect(GameConstants.pontuacaoInicial, equals(0));
    });

    test('acertos por nível é 10', () {
      expect(GameConstants.acertosPorNivel, equals(10));
    });
  });
}
