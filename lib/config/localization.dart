import 'dart:ui';

class AppLocalization {
  AppLocalization._();

  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en'),
    Locale('it'),
  ];

  static const Locale fallbackLocale = Locale('pt', 'BR');
}
