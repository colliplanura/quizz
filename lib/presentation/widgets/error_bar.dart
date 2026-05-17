import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ErrorBar extends StatelessWidget {
  const ErrorBar({super.key, required this.errosAtuais});

  final int errosAtuais;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        GameConstants.maxErrosConsecutivos,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < errosAtuais
                ? Colors.redAccent
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          child: i < errosAtuais
              ? const Icon(Icons.close, color: Colors.white, size: 20)
              : null,
        ),
      ),
    );
  }
}
