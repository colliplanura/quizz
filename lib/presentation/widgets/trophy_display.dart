import 'package:flutter/material.dart';

class TrophyDisplay extends StatelessWidget {
  const TrophyDisplay({
    super.key,
    required this.nivel,
    required this.pontuacao,
    required this.trofeus,
  });

  final int nivel;
  final int pontuacao;
  final int trofeus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          _StatChip(icon: Icons.bar_chart, value: 'N$nivel'),
          const SizedBox(width: 4),
          _StatChip(icon: Icons.star, value: '$pontuacao'),
          const SizedBox(width: 4),
          _StatChip(icon: Icons.emoji_events, value: '$trofeus'),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
