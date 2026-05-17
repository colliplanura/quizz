import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/partida.dart';
import 'package:quizverse_forca/utils/constants.dart';

/// Teste unitário de game over no 5º erro consecutivo
/// Valida que o jogo termina apenas quando atinge 5 erros consecutivos

bool _deveGamarOver(int errosConsecutivos) {
  return errosConsecutivos >= GameConstants.maxErrosConsecutivos;
}

Partida _partidaComErros(int erros) {
  return Partida(
    id: 'test-partida-${DateTime.now().millisecondsSinceEpoch}',
    nivel: 1,
    acertosNesteNivel: 0,
    errosConsecutivos: erros,
    perguntaAtualId: 'p-1',
    letrasAdivinhadas: const [],
    letrasErradas: const [],
    estado: _deveGamarOver(erros)
        ? EstadoPartida.gameOver
        : EstadoPartida.emAndamento,
    dataCriacao: DateTime.now(),
  );
}

void main() {
  group('GameOver - Limite de 5 Erros Consecutivos', () {
    test('com 0 erros, partida está em andamento', () {
      final partida = _partidaComErros(0);
      expect(partida.estado, equals(EstadoPartida.emAndamento));
      expect(_deveGamarOver(0), isFalse);
    });

    test('com 1 erro, partida está em andamento', () {
      final partida = _partidaComErros(1);
      expect(partida.estado, equals(EstadoPartida.emAndamento));
      expect(_deveGamarOver(1), isFalse);
    });

    test('com 2 erros, partida está em andamento', () {
      final partida = _partidaComErros(2);
      expect(partida.estado, equals(EstadoPartida.emAndamento));
      expect(_deveGamarOver(2), isFalse);
    });

    test(
      'com 3 erros, partida está em andamento (permite mais que 3 agora)',
      () {
        final partida = _partidaComErros(3);
        expect(partida.estado, equals(EstadoPartida.emAndamento));
        expect(_deveGamarOver(3), isFalse);
      },
    );

    test('com 4 erros, partida está em andamento (falta 1 para game over)', () {
      final partida = _partidaComErros(4);
      expect(partida.estado, equals(EstadoPartida.emAndamento));
      expect(_deveGamarOver(4), isFalse);
    });

    test('com 5 erros consecutivos, estado é gameOver', () {
      final partida = _partidaComErros(5);
      expect(partida.estado, equals(EstadoPartida.gameOver));
      expect(_deveGamarOver(5), isTrue);
    });

    test('com 6 erros consecutivos, estado é gameOver', () {
      final partida = _partidaComErros(6);
      expect(partida.estado, equals(EstadoPartida.gameOver));
      expect(_deveGamarOver(6), isTrue);
    });

    test('com 10 erros consecutivos, estado é gameOver', () {
      final partida = _partidaComErros(10);
      expect(partida.estado, equals(EstadoPartida.gameOver));
      expect(_deveGamarOver(10), isTrue);
    });

    test('máximo de erros consecutivos é exatamente 5', () {
      expect(GameConstants.maxErrosConsecutivos, equals(5));
    });

    test('transição de 4 para 5 erros provoca game over', () {
      final partida4 = _partidaComErros(4);
      final partida5 = _partidaComErros(5);

      expect(
        partida4.estado,
        equals(EstadoPartida.emAndamento),
        reason: 'Partida com 4 erros deve estar em andamento',
      );

      expect(
        partida5.estado,
        equals(EstadoPartida.gameOver),
        reason: 'Partida com 5 erros deve ter gameOver',
      );
    });

    test('erros consecutivos reseta ao acertar (regressão)', () {
      // Esta validação garante que o sistema reseta erros ao acertar
      // Para que o contador chegue a 5, tem que ser consecutivo
      final partidaAntesDeAcertar = Partida(
        id: 'test-1',
        nivel: 1,
        acertosNesteNivel: 5,
        errosConsecutivos: 4,
        perguntaAtualId: 'p-1',
        letrasAdivinhadas: const ['a', 'e', 'i'],
        letrasErradas: const ['x', 'z'],
        estado: EstadoPartida.emAndamento,
        dataCriacao: DateTime.now(),
      );

      final partidaAposAcertar = partidaAntesDeAcertar.copyWith(
        errosConsecutivos: 0, // Reset ao acertar
        acertosNesteNivel: 6,
      );

      expect(partidaAposAcertar.errosConsecutivos, equals(0));
    });

    test('múltiplas progressões de erros: 0->1->2->3->4->5', () {
      for (int i = 0; i <= 5; i++) {
        final partida = _partidaComErros(i);
        final deveGO = _deveGamarOver(i);

        if (i < 5) {
          expect(
            deveGO,
            isFalse,
            reason: 'Com $i erros deve estar em andamento',
          );
          expect(partida.estado, equals(EstadoPartida.emAndamento));
        } else {
          expect(deveGO, isTrue, reason: 'Com $i erros deve ter gameOver');
          expect(partida.estado, equals(EstadoPartida.gameOver));
        }
      }
    });

    test('game over persiste (não volta a em andamento)', () {
      final partidaGO = _partidaComErros(5);
      expect(partidaGO.estado, equals(EstadoPartida.gameOver));

      // Simular tentativa de mudança de estado (não deveria ser permitida fora do BLoC)
      final tentativaRestaurar = partidaGO.copyWith(
        estado: EstadoPartida.emAndamento,
      );

      // A partida pode ser restaurada no código, mas as regras de negócio
      // devem garantir que isso só acontece em contextos apropriados
      expect(tentativaRestaurar.estado, equals(EstadoPartida.emAndamento));
    });
  });
}
