import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/progresso.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Regras de continuar / reiniciar partida', () {
    Progresso progressoComTrofeus(int trofeus) => Progresso(
          id: GameConstants.idProgressoJogador,
          nivelAtual: 3,
          pontuacaoTotal: 50,
          trofeusGanhos: trofeus,
          acertosConsecutivos: 0,
          errosConsecutivos: 0,
          timestampUltimaSincronizacao: DateTime.fromMillisecondsSinceEpoch(0),
        );

    test('continuar custa exatamente 1 troféu', () {
      expect(GameConstants.custoTrofeuContinuar, equals(1));
    });

    test('ao continuar, trofeus decrementam em 1', () {
      final progresso = progressoComTrofeus(3);
      final atualizado = progresso.copyWith(
        trofeusGanhos: progresso.trofeusGanhos - GameConstants.custoTrofeuContinuar,
      );
      expect(atualizado.trofeusGanhos, equals(2));
    });

    test('não pode continuar com 0 troféus', () {
      final progresso = progressoComTrofeus(0);
      final podeContinuar = progresso.trofeusGanhos >= GameConstants.custoTrofeuContinuar;
      expect(podeContinuar, isFalse);
    });

    test('pode continuar quando tem pelo menos 1 troféu', () {
      final progresso = progressoComTrofeus(1);
      final podeContinuar = progresso.trofeusGanhos >= GameConstants.custoTrofeuContinuar;
      expect(podeContinuar, isTrue);
    });

    test('ao reiniciar, nivel volta para 1', () {
      final progresso = progressoComTrofeus(0);
      final reiniciado = progresso.copyWith(
        nivelAtual: GameConstants.nivelInicial,
        pontuacaoTotal: GameConstants.pontuacaoInicial,
        acertosConsecutivos: 0,
        errosConsecutivos: 0,
      );
      expect(reiniciado.nivelAtual, equals(GameConstants.nivelInicial));
      expect(reiniciado.pontuacaoTotal, equals(GameConstants.pontuacaoInicial));
    });

    test('trofeus iniciais ao criar novo jogo são 1', () {
      expect(GameConstants.trofeusIniciais, equals(1));
    });

    test('ao reiniciar, trofeus NÃO são resetados (mantém histórico)', () {
      final progresso = progressoComTrofeus(5);
      final reiniciado = progresso.copyWith(
        nivelAtual: GameConstants.nivelInicial,
        pontuacaoTotal: GameConstants.pontuacaoInicial,
        acertosConsecutivos: 0,
        errosConsecutivos: 0,
      );
      // trofeus permanecem (não resetam ao reiniciar)
      expect(reiniciado.trofeusGanhos, equals(5));
    });
  });
}
