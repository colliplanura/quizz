import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/config/localization.dart';
import 'package:quizverse_forca/utils/validators.dart';

void main() {
  group('Testes de localização', () {
    test('idiomas suportados: pt_BR, en, it', () {
      final locales = AppLocalization.supportedLocales;
      expect(locales.any((l) => l.languageCode == 'pt'), isTrue);
      expect(locales.any((l) => l.languageCode == 'en'), isTrue);
      expect(locales.any((l) => l.languageCode == 'it'), isTrue);
    });

    test('locale padrão é pt_BR', () {
      expect(AppLocalization.fallbackLocale.languageCode, equals('pt'));
      expect(AppLocalization.fallbackLocale.countryCode, equals('BR'));
    });

    test('fallback de contexto para pt_BR quando idioma ausente', () {
      final ctx = {'pt_BR': 'Contexto em português'};
      expect(Validators.obterContexto(ctx, 'en'), equals('Contexto em português'));
      expect(Validators.obterContexto(ctx, 'it'), equals('Contexto em português'));
    });

    test('retorna contexto correto para idioma disponível', () {
      final ctx = {
        'pt_BR': 'Contexto PT',
        'en': 'Context EN',
        'it': 'Contesto IT',
      };
      expect(Validators.obterContexto(ctx, 'pt_BR'), equals('Contexto PT'));
      expect(Validators.obterContexto(ctx, 'en'), equals('Context EN'));
      expect(Validators.obterContexto(ctx, 'it'), equals('Contesto IT'));
    });
  });

  group('Testes de normalização de resposta', () {
    test('normaliza acentos', () {
      expect(Validators.normalizarResposta('Brasília'), equals('brasilia'));
      expect(Validators.normalizarResposta('São Paulo'), equals('sao paulo'));
      expect(Validators.normalizarResposta('Açaí'), equals('acai'));
    });

    test('converte para minúsculas', () {
      expect(Validators.normalizarResposta('BRASIL'), equals('brasil'));
    });

    test('letras de a-z são válidas', () {
      expect(Validators.letraValida('a'), isTrue);
      expect(Validators.letraValida('z'), isTrue);
      expect(Validators.letraValida('á'), isTrue);
    });

    test('strings com mais de 1 caractere são inválidas', () {
      expect(Validators.letraValida('ab'), isFalse);
    });

    test('números são inválidos', () {
      expect(Validators.letraValida('1'), isFalse);
    });
  });
}
