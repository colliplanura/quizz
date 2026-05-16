# Quickstart: QuizVerse: Forca Development Environment

**Phase**: Phase 1 (Design)  
**Date**: 2026-05-16  
**Target Audience**: Flutter developers ready to begin implementation

---

## Prerequisites

Before starting, ensure you have:

- **Flutter SDK**: 3.x or later ([flutter.dev](https://flutter.dev))
- **Dart SDK**: 3.x or later (bundled with Flutter)
- **Git**: Latest version
- **IDE**: Android Studio, VS Code, or Xcode (for iOS development)
- **Android Emulator** or **iOS Simulator** (optional, can test on physical device)

**Verification**:
```bash
flutter --version
dart --version
git --version
```

---

## Initial Project Setup

### 1. Clone Repository

```bash
cd ~/projects  # or your preferred location
git clone https://github.com/colliplanura/quizz.git
cd quizz
git checkout 001-quizverse-forca
```

### 2. Create Flutter Project (if not exists)

If the repository doesn't have a Flutter project yet:

```bash
flutter create --org com.quizverse quizz
# or
flutter create .  # in-place
```

### 3. Install Dependencies

```bash
flutter pub get
```

This installs packages defined in `pubspec.yaml` based on the spec's recommendations:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.0          # Local storage
  hive_flutter: ^1.1.0
  # BLoC or Riverpod (choose one):
  bloc: ^8.1.0          # OR riverpod: ^2.4.0
  flutter_bloc: ^8.1.0  # OR flutter_riverpod: ^2.4.0
  easy_localization: ^3.0.0  # Localization (PT-BR, EN, IT)
  http: ^1.1.0          # GitHub API calls

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0       # Testing
  bloc_test: ^9.1.0     # BLoC testing (if BLoC chosen)
```

---

## Project Structure

After setup, create the Clean Architecture directories:

```bash
mkdir -p lib/{data,domain,presentation,utils,config,services}
mkdir -p lib/data/{datasources,models,repositories}
mkdir -p lib/domain/{entities,repositories,usecases}
mkdir -p lib/presentation/{bloc,pages,widgets,screens}
mkdir -p test/{unit,widget,integration}
```

Or use the template from `specs/001-quizverse-forca/plan.md#project-structure`.

---

## Configuration Files

### pubspec.yaml

Ensure these sections are configured:

**Flutter Section**:
```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/locales/  # For easy_localization JSON files
    - assets/icons/    # For trophy icons, etc.

  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
```

### main.dart (Bootstrap)

```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; or flutter_riverpod

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Initialize localization
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('pt', 'BR'), Locale('en'), Locale('it')],
      path: 'assets/locales',
      fallbackLocale: Locale('pt', 'BR'),
      child: const QuizVerseApp(),
    ),
  );
}

class QuizVerseApp extends StatelessWidget {
  const QuizVerseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizVerse: Forca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuizVerse: Forca')),
      body: const Center(child: Text('Coming soon!')),
    );
  }
}
```

---

## Localization Setup

### Create Translation Files

Create JSON files in `assets/locales/`:

**assets/locales/pt_BR.json**:
```json
{
  "app_title": "QuizVerse: Forca",
  "home_title": "Bem-vindo",
  "play_button": "Jogar",
  "settings_button": "Configurações",
  "question_label": "Pergunta:",
  "your_answer": "Sua resposta:",
  "correct": "Correto!",
  "incorrect": "Errado!",
  "game_over": "Fim de Jogo",
  "continue": "Continuar (1 troféu)",
  "restart": "Reiniciar",
  "level": "Nível",
  "score": "Pontuação",
  "trophies": "Troféus"
}
```

**assets/locales/en.json**:
```json
{
  "app_title": "QuizVerse: Hangman",
  "home_title": "Welcome",
  "play_button": "Play",
  "settings_button": "Settings",
  ...
}
```

**assets/locales/it.json**:
```json
{
  "app_title": "QuizVerse: Forca",
  "home_title": "Benvenuto",
  "play_button": "Gioca",
  "settings_button": "Impostazioni",
  ...
}
```

### Usage in Code

```dart
import 'package:easy_localization/easy_localization.dart';

Text('app_title'.tr())  // Translates to user's language
Text('play_button'.tr()) // Fallback to PT-BR if missing
```

---

## Hive Setup

### Define Adapters

Create `lib/data/datasources/local/hive_adapter.dart`:

```dart
import 'package:hive/hive.dart';
import '../models/pergunta_model.dart';
// ... import other models

class HiveAdapter {
  static Future<void> registerAdapters() async {
    Hive.registerAdapter(PerguntaModelAdapter());
    Hive.registerAdapter(ProgressoModelAdapter());
    // ... register other adapters
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<PerguntaModel>('perguntas');
    await Hive.openBox<ProgressoModel>('progresso');
    await Hive.openBox<PartidaModel>('partida_ativa');
    await Hive.openBox<TrofeuModel>('trofeus');
    await Hive.openBox<ConfigIdiomaModel>('config_idioma');
  }
}
```

Call in `main()` before `runApp()`:

```dart
await HiveAdapter.registerAdapters();
await HiveAdapter.openBoxes();
```

---

## First Debug Run

### Run on Emulator/Simulator

```bash
# iOS Simulator
flutter run

# Android Emulator
flutter run

# Specify device
flutter devices
flutter run -d <device_id>
```

### Expected Output

- App launches with home screen
- "Coming soon!" message displays
- No errors in console (or only warnings about dependencies)

---

## Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b feature/game-rules
```

### 2. Implement Domain Layer First

```bash
# lib/domain/entities/pergunta.dart
class Pergunta {
  final String id;
  final String pergunta;
  final String resposta; // normalized
  final String exibicao_resposta;
  // ... (from data-model.md)
}
```

### 3. Implement Data Layer

```bash
# lib/data/datasources/local/pergunta_local_source.dart
class PerguntaLocalSource {
  Future<List<Pergunta>> getPerguntas() async {
    final box = Hive.box<PerguntaModel>('perguntas');
    return box.values.map((m) => m.toEntity()).toList();
  }
}
```

### 4. Implement Presentation Layer (BLoC/Riverpod)

Choose one:

**Option A: BLoC**
```bash
# lib/presentation/bloc/game_bloc.dart
class GameBloc extends Bloc<GameEvent, GameState> {
  // Implement game logic
}
```

**Option B: Riverpod**
```bash
# lib/presentation/providers/game_provider.dart
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  // Implement game logic
});
```

### 5. Create UI Widgets

```bash
# lib/presentation/pages/game_page.dart
class GamePage extends StatelessWidget {
  // Implement game UI
}
```

---

## Testing

### Unit Test Example

```dart
// test/unit/domain/usecases/play_game_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayGame UseCase', () {
    test('should start game at level 1', () {
      // Arrange
      final usecase = PlayGame(mockRepository);

      // Act
      final result = usecase.call();

      // Assert
      expect(result.nivel, 1);
      expect(result.pontuacao, 0);
      expect(result.trofeus, 1);
    });
  });
}
```

### Run Tests

```bash
flutter test
flutter test test/unit/domain/
flutter test --coverage
```

---

## Common Tasks

### Add a New Dependency

```bash
flutter pub add package_name
flutter pub get
```

### Format Code

```bash
dart format lib test
```

### Lint

```bash
flutter analyze
```

### Clean Build

```bash
flutter clean
flutter pub get
flutter run
```

### Build APK (Android)

```bash
flutter build apk --release
```

### Build iOS App

```bash
flutter build ios --release
```

---

## Resources

- **Flutter Documentation**: [flutter.dev/docs](https://flutter.dev/docs)
- **Dart Language**: [dart.dev](https://dart.dev)
- **Hive Documentation**: [docs.hivedb.dev](https://docs.hivedb.dev)
- **BLoC Library**: [bloclibrary.dev](https://bloclibrary.dev)
- **easy_localization**: [github.com/aissat/easy_localization](https://github.com/aissat/easy_localization)
- **Project Spec**: [../spec.md](../spec.md)
- **Data Model**: [../data-model.md](../data-model.md)
- **API Contract**: [../contracts/api-github.md](../contracts/api-github.md)

---

## Next Steps

1. **Run the project**: `flutter run`
2. **Explore Clean Architecture**: Read `lib/main.dart` and existing stubs
3. **Start with Domain**: Implement `lib/domain/entities/` and `lib/domain/usecases/`
4. **Write Tests**: Test domain rules first (quickest feedback)
5. **Build UI**: Implement pages and widgets last
6. **Integrate GitHub Sync**: Implement P2 feature (background tasks, HTTP)
7. **Localization**: Translate UI strings (JSON method)

---

**Quickstart Complete**. Begin Phase 2: Task Generation (`/speckit.tasks`).
