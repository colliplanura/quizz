import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'data/datasources/local/pergunta_local_datasource.dart';
import 'data/datasources/local/progresso_local_datasource.dart';
import 'data/datasources/remote/github_remote_source.dart';
import 'data/repositories/pergunta_repository_impl.dart';
import 'data/repositories/progresso_repository_impl.dart';
import 'data/repositories/sync_repository_impl.dart';
import 'config/localization.dart';
import 'domain/usecases/advance_level.dart';
import 'domain/usecases/check_answer.dart';
import 'domain/usecases/continue_game.dart';
import 'domain/usecases/game_over.dart';
import 'domain/usecases/play_game.dart';
import 'domain/usecases/sync_questions.dart';
import 'presentation/bloc/game_bloc.dart';
import 'presentation/bloc/game_event.dart';
import 'presentation/pages/game_page.dart';
import 'data/datasources/local/hive_service.dart';
import 'services/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await HiveService.inicializar();

  runApp(
    QuizVerseApp(gameBloc: _criarGameBloc()),
  );
}

GameBloc _criarGameBloc() {
  final perguntaLocalDatasource = PerguntaLocalDatasource();
  final progressoLocalDatasource = ProgressoLocalDatasource();
  final perguntaRepository = PerguntaRepositoryImpl(perguntaLocalDatasource);
  final progressoRepository = ProgressoRepositoryImpl(progressoLocalDatasource);
  final syncRepository = SyncRepositoryImpl(
    remoteSource: GithubRemoteSource(),
    perguntaRepository: perguntaRepository,
  );
  final syncQuestions = SyncQuestions(syncRepository);

  return GameBloc(
    playGame: PlayGame(
      perguntaRepository: perguntaRepository,
      progressoRepository: progressoRepository,
    ),
    checkAnswer: CheckAnswer(),
    advanceLevel: AdvanceLevel(
      perguntaRepository: perguntaRepository,
      progressoRepository: progressoRepository,
    ),
    gameOver: GameOver(progressoRepository: progressoRepository),
    continueGame: ContinueGame(
      perguntaRepository: perguntaRepository,
      progressoRepository: progressoRepository,
    ),
    syncService: SyncService(syncQuestions),
  )..add(const GameStarted());
}

class QuizVerseApp extends StatefulWidget {
  const QuizVerseApp({super.key, required this.gameBloc});

  final GameBloc gameBloc;

  @override
  State<QuizVerseApp> createState() => _QuizVerseAppState();
}

class _QuizVerseAppState extends State<QuizVerseApp> {
  @override
  void dispose() {
    widget.gameBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: 'assets/locales',
      fallbackLocale: AppLocalization.fallbackLocale,
      child: BlocProvider.value(
        value: widget.gameBloc,
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'QuizVerse: Forca',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const GamePage(),
            );
          },
        ),
      ),
    );
  }
}
