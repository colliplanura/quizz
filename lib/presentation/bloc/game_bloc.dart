import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/partida.dart' as domain;
import '../../domain/usecases/advance_level.dart';
import '../../domain/usecases/anti_repeticao_usecase.dart';
import '../../domain/usecases/check_answer.dart';
import '../../domain/usecases/continue_game.dart';
import '../../domain/usecases/game_over.dart' as uc;
import '../../domain/usecases/game_over_usecase.dart';
import '../../domain/usecases/play_game.dart';
import '../../utils/validators.dart';
import '../../services/logging_service.dart';
import '../../services/sync_service.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required this.playGame,
    required this.checkAnswer,
    required this.advanceLevel,
    required this.gameOver,
    required this.gameOverUseCase,
    required this.antiRepeticaoUseCase,
    required this.continueGame,
    this.syncService,
  }) : super(const GameInitial()) {
    on<GameStarted>(_onStarted);
    on<GameLetterGuessed>(_onLetterGuessed);
    on<GameContinued>(_onContinued);
    on<GameRestarted>(_onRestarted);
    on<GameRestored>(_onRestored);
  }

  final PlayGame playGame;
  final CheckAnswer checkAnswer;
  final AdvanceLevel advanceLevel;
  final uc.GameOver gameOver;
  final GameOverUseCase gameOverUseCase;
  final AntiRepeticaoUseCase antiRepeticaoUseCase;
  final ContinueGame continueGame;
  final SyncService? syncService;

  Future<void> _onStarted(GameStarted event, Emitter<GameState> emit) async {
    emit(const GameLoading());
    try {
      final result = await playGame.executar();
      emit(
        GameRunning(
          partida: result.partida,
          progresso: result.progresso,
          pergunta: result.pergunta,
        ),
      );
    } catch (e, st) {
      LoggingService.error('Erro ao iniciar jogo', erro: e, stackTrace: st);
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onLetterGuessed(
    GameLetterGuessed event,
    Emitter<GameState> emit,
  ) async {
    final current = state;
    if (current is! GameRunning) return;

    final respostaNorm = Validators.normalizarResposta(
      current.pergunta.resposta,
    );
    final result = checkAnswer.executar(
      partida: current.partida,
      progresso: current.progresso,
      respostaNormalizada: respostaNorm,
      letrasDigitadas: event.letra,
    );

    // Verificar game over com a regra de 5 erros consecutivos (T047)
    if (gameOverUseCase.verificarGameOver(result.partida)) {
      final goResult = await gameOver.executar(
        result.partida,
        result.progresso,
      );
      emit(
        GameOver(
          partida: goResult.partidaFinalizada,
          progresso: result.progresso,
          podeContinuar: goResult.podeContinuar,
        ),
      );
    } else if (result.partida.estado == domain.EstadoPartida.nivelCompleto) {
      try {
        final lvlResult = await advanceLevel.executar(result.progresso);
        // Dispara sync silencioso em background no level-up (T061)
        syncService?.sincronizarEmBackground(forcarSync: true);
        emit(
          GameLevelUp(
            partida: result.partida,
            progresso: lvlResult.progresso,
            novoNivel: lvlResult.progresso.nivelAtual,
          ),
        );
      } catch (e, st) {
        LoggingService.error('Erro ao avançar nível', erro: e, stackTrace: st);
        emit(GameError(e.toString()));
      }
    } else {
      final palavraCompleta =
          result.partida.acertosNesteNivel > current.partida.acertosNesteNivel;
      if (palavraCompleta) {
        try {
          final proxResult = await playGame.proximaRodada(
            progresso: result.progresso,
            nivel: result.partida.nivel,
          );
          emit(
            GameRunning(
              partida: proxResult.partida,
              progresso: proxResult.progresso,
              pergunta: proxResult.pergunta,
            ),
          );
        } catch (e, st) {
          LoggingService.error(
            'Erro ao carregar próxima pergunta',
            erro: e,
            stackTrace: st,
          );
          emit(GameError(e.toString()));
        }
      } else {
        emit(
          GameRunning(
            partida: result.partida,
            progresso: result.progresso,
            pergunta: current.pergunta,
          ),
        );
      }
    }
  }

  Future<void> _onContinued(
    GameContinued event,
    Emitter<GameState> emit,
  ) async {
    final current = state;
    if (current is! GameOver) return;

    emit(const GameLoading());
    try {
      final result = await continueGame.continuar(current.progresso);
      emit(
        GameRunning(
          partida: result.novaPartida,
          progresso: result.progresso,
          pergunta: result.pergunta,
        ),
      );
    } catch (e, st) {
      LoggingService.error('Erro ao continuar jogo', erro: e, stackTrace: st);
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onRestarted(
    GameRestarted event,
    Emitter<GameState> emit,
  ) async {
    final current = state;
    if (current is! GameOver) return;

    emit(const GameLoading());
    try {
      final result = await continueGame.reiniciar(current.progresso);
      emit(
        GameRunning(
          partida: result.novaPartida,
          progresso: result.progresso,
          pergunta: result.pergunta,
        ),
      );
    } catch (e, st) {
      LoggingService.error('Erro ao reiniciar jogo', erro: e, stackTrace: st);
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onRestored(GameRestored event, Emitter<GameState> emit) async {
    emit(const GameLoading());
    try {
      final result = await playGame.executar();
      emit(
        GameRunning(
          partida: result.partida,
          progresso: result.progresso,
          pergunta: result.pergunta,
        ),
      );
    } catch (e, st) {
      LoggingService.error('Erro ao restaurar jogo', erro: e, stackTrace: st);
      emit(GameError(e.toString()));
    }
  }
}
