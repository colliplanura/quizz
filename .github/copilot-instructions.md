	<!-- SPECKIT START -->
	For additional context about technologies to be used, project structure,
	shell commands, and other important information, read the current plan at:
	`specs/002-expand-question-bank/plan.md`

	Supporting documents:
	- Specification: `specs/002-expand-question-bank/spec.md` (P1/P2/P3 user stories, requirements)
	- Data Model: `specs/002-expand-question-bank/data-model.md` (entity definitions, schema)
	- Question Contract: `specs/002-expand-question-bank/contracts/question-catalog.md` (catalog and selection rules)
	- Quickstart: `specs/002-expand-question-bank/quickstart.md` (dev environment setup)
	- Constitution: `.specify/memory/constitution.md` (governance, principles v2.0.0)

	Key technical decisions:
	- Flutter 3.x + Dart 3.x (Mobile iOS/Android)
	- Clean Architecture (Data/Domain/Presentation layers)
	- BLoC 8.x or Riverpod 2.x (state management, choose during Phase 2)
	- Hive 2.x for local offline-first storage
	- easy_localization for PT-BR/EN/IT support
	- GitHub raw endpoint for question sync (24h or on level-up)
	- Weighted random difficulty distribution by game level
	- Anti-repetition window of 2h (wall-clock) with history reset fallback
	- Game over only at 5 consecutive errors (Princípio V)

	All documentation is in Portuguese (Brasil) per constitution v2.0.0.
	<!-- SPECKIT END -->
