import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../widgets/error_bar.dart';
import '../widgets/letra_button.dart';
import '../widgets/palavras_display.dart';
import '../widgets/trophy_display.dart';
import '../widgets/level_up_celebration.dart';
import '../../utils/constants.dart';
import 'game_over_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is GameRunning) {
                return TrophyDisplay(
                  nivel: state.progresso.nivelAtual,
                  pontuacao: state.progresso.pontuacaoTotal,
                  trofeus: state.progresso.trofeusGanhos,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameLevelUp) {
            _mostrarCelebracaoNivel(context, state.novoNivel);
          } else if (state is GameOver) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<GameBloc>(),
                  child: GameOverPage(
                    partida: state.partida,
                    progresso: state.progresso,
                    podeContinuar: state.podeContinuar,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GameLoading || state is GameInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GameError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.mensagem),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<GameBloc>().add(const GameStarted()),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }
          if (state is GameRunning) {
            return _buildGameUI(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGameUI(BuildContext context, GameRunning state) {
    final letrasAlfabeto = 'abcdefghijklmnopqrstuvwxyz'.split('');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Semantics(
            label: 'Erros consecutivos: ${state.partida.errosConsecutivos} de ${GameConstants.maxErrosConsecutivos}',
            child: ExcludeSemantics(child: ErrorBar(errosAtuais: state.partida.errosConsecutivos)),
          ),
          const SizedBox(height: 24),
          PalavrasDisplay(
            resposta: state.pergunta.resposta,
            exibicaoResposta: state.pergunta.exibicaoResposta,
            letrasAdivinhadas: state.partida.letrasAdivinhadas,
          ),
          const SizedBox(height: 16),
          Text(
            state.pergunta.pergunta,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: letrasAlfabeto.map((letra) {
                final adivinhada = state.partida.letrasAdivinhadas.contains(letra);
                final errada = state.partida.letrasErradas.contains(letra);
                return LetraButton(
                  letra: letra,
                  habilitada: !adivinhada && !errada,
                  acertou: adivinhada,
                  onPressed: () => context
                      .read<GameBloc>()
                      .add(GameLetterGuessed(letra)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarCelebracaoNivel(BuildContext context, int novoNivel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelUpCelebration(
        novoNivel: novoNivel,
        onContinuar: () {
          Navigator.of(context).pop();
          context.read<GameBloc>().add(const GameStarted());
        },
      ),
    );
  }
}
