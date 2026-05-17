# QuizVerse: Forca

Jogo da forca educativo offline-first para iOS e Android. Construído com Flutter 3.x + Clean Architecture + BLoC 8.x.

## Funcionalidades

- **US1 — Jogo Offline**: Jogar forca sem conexão, progresso persistido localmente (Hive).
- **US2 — Sync de Perguntas**: Sincronização silenciosa de perguntas via GitHub raw endpoint (a cada 24h ou ao subir de nível).
- **US3 — Internacionalização**: Suporte a PT-BR, English e Italiano via easy_localization.

## Tecnologias

| Camada | Tecnologia |
|--------|-----------|
| UI | Flutter 3.x |
| Estado | BLoC 8.x |
| Persistência local | Hive 2.x |
| i18n | easy_localization 3.x |
| HTTP | http ^1.2.2 |
| Testes | flutter_test + mockito + bloc_test |

## Arquitetura

```
lib/
	config/          # Localização e configurações globais
	data/            # Modelos, datasources (local/remote), repositories impl
	domain/          # Entidades, repositórios abstratos, use cases
	presentation/    # BLoC, páginas e widgets
	services/        # Sync, logging, persistência de estado
	utils/           # Constants, helpers
```

## Como rodar

### Pré-requisitos

- Flutter 3.x (`flutter --version`)
- Dart 3.x
- iOS Simulator ou Android Emulator

### Instalação

```bash
git clone <repo-url>
cd quizz
flutter pub get
flutter run
```

### Testes

```bash
# Todos os testes unitários e de integração
flutter test test/unit/ test/integration/

# Com cobertura
flutter test --coverage test/unit/ test/integration/
genhtml coverage/lcov.info -o coverage/html
```

### Análise estática

```bash
flutter analyze
```

## Cobertura de Testes

Cobertura ≥90% das regras de jogo é **obrigatória** (Princípio III da Constituição). Casos cobertos:

- Regras de game over (3 erros consecutivos)
- Progressão de nível (10 acertos)
- Sistema de troféus (continuar/reiniciar)
- Sincronização de perguntas (intervalo 24h, HTTPS)
- Internacionalização (fallback pt_BR, normalização)
- Restauração de estado offline

## Sync de Perguntas

As perguntas são sincronizadas do repositório GitHub em formato JSON. O endpoint é configurado em `lib/utils/constants.dart`. Apenas conexões HTTPS são aceitas.

Formato esperado:

```json
[
	{
		"id": "uuid",
		"categoria": "historia",
		"dificuldade": 1,
		"pergunta": "Texto da pergunta",
		"resposta": "palavra",
		"exibicao_resposta": "Palavra Completa",
		"contexto_historico": {
			"pt_BR": "Contexto em português",
			"en": "Context in English",
			"it": "Contesto in italiano"
		}
	}
]
```

## Licença

Veja [LICENSE](LICENSE).
