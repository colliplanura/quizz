import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LevelUpCelebration extends StatelessWidget {
  const LevelUpCelebration({
    super.key,
    required this.novoNivel,
    required this.onContinuar,
  });

  final int novoNivel;
  final VoidCallback onContinuar;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              'level_up'.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${'level'.tr()} $novoNivel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onContinuar,
              child: Text('continue_game'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
