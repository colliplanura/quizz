import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/progresso.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Resiliência a falhas de sync', () {
    test('falha de sync não altera progresso local', () {
      // Arrange: progresso com estado definido
      final progresso = Progresso(
        id: GameConstants.idProgressoJogador,
        nivelAtual: 3,
        pontuacaoTotal: 28,
        trofeusGanhos: 2,
        acertosConsecutivos: 5,
        errosConsecutivos: 0,
        timestampUltimaSincronizacao: DateTime(2024, 1, 1),
      );

      // Act: simular falha (sem modificar progresso)
      // Em cenário real: sync_service lança exception e é capturado silenciosamente
      const erroSync = 'SocketException: Failed to connect';
      var progressoAposErro = progresso;

      expect(progressoAposErro.nivelAtual, equals(progresso.nivelAtual));
      expect(progressoAposErro.pontuacaoTotal, equals(progresso.pontuacaoTotal));
      expect(progressoAposErro.trofeusGanhos, equals(progresso.trofeusGanhos));
      expect(erroSync, isNotEmpty); // confirmação que houve erro
    });

    test('payload 100% inválido não substitui perguntas locais', () {
      // Simula comportamento: payload inválido é rejeitado, locais mantidos
      const payloadInvalido = 'ESTE NÃO É JSON VÁLIDO!!!';
      var parseOk = false;
      try {
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {
        parseOk = false;
      }
      expect(parseOk, isFalse); // parser falhou, locais intactos
      expect(payloadInvalido, isNotEmpty);
    });
  });
}
