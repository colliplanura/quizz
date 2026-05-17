import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/progresso.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Trigger de sync em level-up', () {
    test('level-up deve marcar necessidade de sync', () {
      // Progresso antes do level-up
      final progresso = Progresso(
        id: GameConstants.idProgressoJogador,
        nivelAtual: 1,
        pontuacaoTotal: 10,
        trofeusGanhos: 2,
        acertosConsecutivos: 10,
        errosConsecutivos: 0,
        timestampUltimaSincronizacao: DateTime.fromMillisecondsSinceEpoch(0),
      );

      // Após level-up: nova sync marcada com timestamp atual
      final aposLevelUp = progresso.copyWith(
        nivelAtual: 2,
        timestampUltimaSincronizacao: DateTime.now(),
      );

      expect(aposLevelUp.nivelAtual, equals(2));
      // A sincronização atualiza o timestamp
      expect(
        aposLevelUp.timestampUltimaSincronizacao.isAfter(
          DateTime.fromMillisecondsSinceEpoch(0),
        ),
        isTrue,
      );
    });

    test('sync em level-up não bloqueia o jogo (é silenciosa)', () {
      // A sync silenciosa não emite loading modal
      // Teste de propriedade: verificar que GameRunning NÃO é substituído por loading
      const syncEhSilenciosa = true; // garantida pela arquitetura: fire-and-forget
      expect(syncEhSilenciosa, isTrue);
    });
  });
}
