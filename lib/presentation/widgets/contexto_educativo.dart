import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../utils/validators.dart';

class ContextoEducativo extends StatelessWidget {
  const ContextoEducativo({
    super.key,
    required this.contextoHistorico,
  });

  final Map<String, String> contextoHistorico;

  @override
  Widget build(BuildContext context) {
    final codigoIdioma = context.locale.languageCode;
    final codigoCompleto = context.locale.countryCode != null
        ? '${context.locale.languageCode}_${context.locale.countryCode}'
        : codigoIdioma;

    final texto = contextoHistorico[codigoCompleto] ??
        contextoHistorico[codigoIdioma] ??
        Validators.obterContexto(contextoHistorico, 'pt_BR');

    if (texto.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
