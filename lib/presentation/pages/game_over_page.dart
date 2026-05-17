import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/partida.dart';
import '../../domain/entities/progresso.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../widgets/trophy_display.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({
    super.key,
    required this.partida,
    required this.progresso,
    required this.podeContinuar,
  });

  final Partida partida;
  final Progresso progresso;
  final bool podeContinuar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Game over',
                child: const Icon(Icons.sentiment_dissatisfied, size: 72, color: Colors.redAccent),
              ),
              const SizedBox(height: 16),
              Text(
                'game_over_title'.tr(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              TrophyDisplay(
                nivel: progresso.nivelAtual,
                pontuacao: progresso.pontuacaoTotal,
                trofeus: progresso.trofeusGanhos,
              ),
              const SizedBox(height: 32),
              if (podeContinuar) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.emoji_events),
                  label: Text('continue_game'.tr()),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<GameBloc>().add(const GameContinued());
                  },
                ),
                const SizedBox(height: 12),
              ] else ...[
                Text(
                  'no_trophies_message'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text('restart_game'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<GameBloc>().add(const GameRestarted());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
