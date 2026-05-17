import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Regras de sincronização de perguntas', () {
    test('deve sincronizar quando passou mais de 24h', () {
      final ultimaSync = DateTime.now().subtract(const Duration(hours: 25));
      final deveSync = DateTime.now().difference(ultimaSync) > GameConstants.intervaloSync;
      expect(deveSync, isTrue);
    });

    test('não deve sincronizar quando passou menos de 24h', () {
      final ultimaSync = DateTime.now().subtract(const Duration(hours: 10));
      final deveSync = DateTime.now().difference(ultimaSync) > GameConstants.intervaloSync;
      expect(deveSync, isFalse);
    });

    test('deve sincronizar quando timestamp é epoch (nunca sincronizou)', () {
      final ultimaSync = DateTime.fromMillisecondsSinceEpoch(0);
      final deveSync = DateTime.now().difference(ultimaSync) > GameConstants.intervaloSync;
      expect(deveSync, isTrue);
    });

    test('intervalo de sync é 24 horas', () {
      expect(GameConstants.intervaloSync.inHours, equals(24));
    });

    test('URL do GitHub é HTTPS', () {
      expect(GameConstants.urlPerguntasGithub, startsWith('https://'));
    });

    test('URL aponta para raw.githubusercontent.com', () {
      expect(GameConstants.urlPerguntasGithub, contains('raw.githubusercontent.com'));
    });
  });
}
