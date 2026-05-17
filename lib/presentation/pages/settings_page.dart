import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/localization.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: ListView(
        children: AppLocalization.supportedLocales.map((locale) {
          final label = _nomeIdioma(locale.languageCode);
          final isAtual = context.locale == locale;
          return ListTile(
            leading: const Icon(Icons.language),
            title: Text(label),
            trailing: isAtual ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () => context.setLocale(locale),
          );
        }).toList(),
      ),
    );
  }

  String _nomeIdioma(String code) {
    return switch (code) {
      'pt' => 'Português (Brasil)',
      'en' => 'English',
      'it' => 'Italiano',
      _ => code,
    };
  }
}
