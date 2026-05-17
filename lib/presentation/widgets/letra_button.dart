import 'package:flutter/material.dart';

class LetraButton extends StatelessWidget {
  const LetraButton({
    super.key,
    required this.letra,
    required this.habilitada,
    required this.acertou,
    required this.onPressed,
  });

  final String letra;
  final bool habilitada;
  final bool acertou;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;
    if (!habilitada) {
      bgColor = acertou ? Colors.green.shade700 : Colors.grey.shade500;
      textColor = Colors.white;
    } else {
      bgColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
    }

    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: bgColor,
          foregroundColor: textColor,
          disabledBackgroundColor: bgColor,
          disabledForegroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: habilitada ? onPressed : null,
        child: Text(
          letra.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
