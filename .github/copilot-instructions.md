	<!-- SPECKIT START -->
	For additional context about technologies to be used, project structure,
	shell commands, and other important information, read the current plan at:
	`specs/001-quizverse-forca/plan.md`

	Supporting documents:
	- Specification: `specs/001-quizverse-forca/spec.md` (P1/P2/P3 user stories, requirements)
	- Data Model: `specs/001-quizverse-forca/data-model.md` (entity definitions, schema)
	- GitHub API Contract: `specs/001-quizverse-forca/contracts/api-github.md` (sync interface)
	- Quickstart: `specs/001-quizverse-forca/quickstart.md` (dev environment setup)
	- Constitution: `.specify/memory/constitution.md` (governance, principles v1.1.0)

	Key technical decisions:
	- Flutter 3.x + Dart 3.x (Mobile iOS/Android)
	- Clean Architecture (Data/Domain/Presentation layers)
	- BLoC 8.x or Riverpod 2.x (state management, choose during Phase 2)
	- Hive 2.x for local offline-first storage
	- easy_localization for PT-BR/EN/IT support
	- GitHub raw endpoint for question sync (24h or on level-up)
	- >= 90% test coverage of game rules (mandatory per Princípio III)

	All documentation is in Portuguese (Brasil) per constitution v1.1.0.
	<!-- SPECKIT END -->
