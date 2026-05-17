# Tasks: QuizVerse: Forca

> Tarefas em Portugues (Brasil), claras e executaveis, organizadas por user story.

**Input**: Artefatos de design de `/specs/001-quizverse-forca/`

**Feature**: 001-quizverse-forca
**Branch**: 001-quizverse-forca
**Status**: Ready for implementation

---

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Pode executar em paralelo (arquivos diferentes, sem dependencia direta)
- **[Story]**: Historia de usuario da tarefa (`[US1]`, `[US2]`, `[US3]`)
- Todo item inclui caminho de arquivo explicito

---

## Phase 1: Setup (Infraestrutura Compartilhada)

**Objetivo**: Preparar bootstrap Flutter, localizacao e base do projeto.

- [ ] T001 Validar estrutura da feature em specs/001-quizverse-forca/ e atualizar links em .github/copilot-instructions.md
- [ ] T002 [P] Configurar dependencias do projeto em ./pubspec.yaml
- [ ] T003 [P] Configurar regras de analise e lint em ./analysis_options.yaml
- [ ] T004 [P] Configurar assets de localizacao e dados em ./pubspec.yaml
- [ ] T005 Consolidar bootstrap da aplicacao com localizacao e inicializacao local em lib/main.dart
- [ ] T006 [P] Revisar traducoes base PT-BR em assets/locales/pt_BR.json
- [ ] T007 [P] Revisar traducoes base EN em assets/locales/en.json
- [ ] T008 [P] Revisar traducoes base IT em assets/locales/it.json

---

## Phase 2: Foundational (Prerequisitos Bloqueantes)

**Objetivo**: Implementar base de dominio/dados para habilitar todas as historias.

**CRITICO**: Nenhuma user story deve iniciar antes desta fase terminar.

- [ ] T009 Implementar constantes globais de regras (10 acertos, 5 erros, estado inicial) em lib/utils/constants.dart
- [ ] T010 [P] Implementar entidade Pergunta em lib/domain/entities/pergunta.dart
- [ ] T011 [P] Implementar entidade Progresso em lib/domain/entities/progresso.dart
- [ ] T012 [P] Implementar entidade Partida em lib/domain/entities/partida.dart
- [ ] T013 [P] Implementar entidade Trofeu em lib/domain/entities/trofeu.dart
- [ ] T014 [P] Implementar entidade ConfiguracaoIdioma em lib/domain/entities/configuracao_idioma.dart
- [ ] T015 Implementar contratos de repositorio em lib/domain/repositories/pergunta_repository.dart
- [ ] T016 [P] Implementar contratos de repositorio em lib/domain/repositories/progresso_repository.dart
- [ ] T017 [P] Implementar contratos de repositorio em lib/domain/repositories/sync_repository.dart
- [ ] T018 Implementar modelos de dados para perguntas e contexto multilíngue em lib/data/models/pergunta_model.dart
- [ ] T019 [P] Implementar modelos de dados de progresso em lib/data/models/progresso_model.dart
- [ ] T020 [P] Implementar modelos de dados de partida em lib/data/models/partida_model.dart
- [ ] T021 [P] Implementar modelos de dados de trofeu em lib/data/models/trofeu_model.dart
- [ ] T022 [P] Implementar modelos de dados de idioma em lib/data/models/configuracao_idioma_model.dart
- [ ] T023 Implementar registro de adaptadores e boxes Hive em lib/data/datasources/local/hive_adapter.dart
- [ ] T024 [P] Implementar datasource de perguntas locais com fallback embarcado em lib/data/datasources/local/pergunta_local_source.dart
- [ ] T025 [P] Implementar datasource de progresso local em lib/data/datasources/local/progresso_local_source.dart
- [ ] T026 [P] Implementar datasource de trofeu e idioma local em lib/data/datasources/local/trofeu_local_source.dart
- [ ] T027 Implementar repositorio concreto de perguntas em lib/data/repositories/pergunta_repository_impl.dart
- [ ] T028 [P] Implementar repositorio concreto de progresso em lib/data/repositories/progresso_repository_impl.dart
- [ ] T029 [P] Implementar validadores de resposta/contexto com fallback para pt_BR em lib/utils/validators.dart
- [ ] T030 Implementar servico de logs para sync e validacao em lib/services/logging_service.dart

**Checkpoint**: Fundacao pronta para iniciar user stories.

---

## Phase 3: User Story 1 - Jogar Forca Offline (Priority: P1) MVP

**Goal**: Entregar ciclo completo de jogo offline com progressao, Game Over em 5 erros e restauracao de estado.

**Independent Test**: Sem internet, iniciar partida, progredir de nivel, acionar Game Over no 5o erro, continuar/reiniciar e reabrir o app mantendo estado esperado.

### Tests for User Story 1

- [ ] T031 [P] [US1] Criar teste unitario de level-up apos 10 acertos em test/unit/domain/usecases/advance_level_test.dart
- [ ] T032 [P] [US1] Criar teste unitario de Game Over no 5o erro em test/unit/domain/usecases/game_over_test.dart
- [ ] T033 [P] [US1] Criar teste unitario de continue/restart com trofeus em test/unit/domain/usecases/continue_game_test.dart
- [ ] T034 [P] [US1] Criar teste de restauracao de partida apos relaunch em test/integration/offline_resume_test.dart
- [ ] T035 [P] [US1] Criar teste de widget para fluxo de jogo offline em test/widget/game_page_test.dart

### Implementation for User Story 1

- [ ] T036 [US1] Implementar caso de uso de iniciar/restaurar partida em lib/domain/usecases/play_game.dart
- [ ] T037 [US1] Implementar caso de uso de validacao de resposta em lib/domain/usecases/check_answer.dart
- [ ] T038 [US1] Implementar caso de uso de progressao de nivel em lib/domain/usecases/advance_level.dart
- [ ] T039 [US1] Implementar caso de uso de Game Over em lib/domain/usecases/game_over.dart
- [ ] T040 [US1] Implementar caso de uso de continuar partida com custo de trofeu em lib/domain/usecases/continue_game.dart
- [ ] T041 [US1] Implementar GameBloc para ciclo de partida em lib/presentation/bloc/game_bloc.dart
- [ ] T042 [P] [US1] Implementar eventos do jogo em lib/presentation/bloc/game_event.dart
- [ ] T043 [P] [US1] Implementar estados do jogo em lib/presentation/bloc/game_state.dart
- [ ] T044 [US1] Implementar tela principal de jogo com regras de erro em lib/presentation/pages/game_page.dart
- [ ] T045 [P] [US1] Implementar componente de palavra mascarada em lib/presentation/widgets/palavras_display.dart
- [ ] T046 [P] [US1] Implementar componente de barra de erros 0-5 em lib/presentation/widgets/error_bar.dart
- [ ] T047 [P] [US1] Implementar grade de letras com estados em lib/presentation/widgets/letra_button.dart
- [ ] T048 [US1] Implementar tela de Game Over com bloquear continuar em lib/presentation/pages/game_over_page.dart
- [ ] T049 [US1] Implementar exibicao de trofeus/nivel/pontuacao em lib/presentation/widgets/trophy_display.dart
- [ ] T050 [US1] Integrar persistencia de estado por transicao em lib/services/game_state_persistence_service.dart
- [ ] T051 [P] [US1] Implementar animacao de celebracao de level-up em lib/presentation/widgets/level_up_celebration.dart

**Checkpoint**: US1 funcional e testavel isoladamente.

---

## Phase 4: User Story 2 - Sincronizar Perguntas do GitHub (Priority: P2)

**Goal**: Sincronizacao silenciosa e resiliente (24h ou level-up), sem interromper o jogo.

**Independent Test**: Durante partida ativa, sincronizar com sucesso e com falha; validar que progresso local e cache permanecem consistentes.

### Tests for User Story 2

- [ ] T052 [P] [US2] Criar teste de contrato do schema de perguntas GitHub em test/unit/data/datasources/github_contract_test.dart
- [ ] T053 [P] [US2] Criar teste de idempotencia de sync por hash e Last-Modified em test/unit/domain/usecases/sync_questions_test.dart
- [ ] T054 [P] [US2] Criar teste de resiliencia para falha de rede/payload invalido em test/integration/sync_failure_resilience_test.dart
- [ ] T055 [P] [US2] Criar teste de trigger de sync ao subir nivel em test/integration/sync_on_level_up_test.dart

### Implementation for User Story 2

- [ ] T056 [US2] Implementar client remoto GitHub com timeout/retry em lib/data/datasources/remote/github_remote_source.dart
- [ ] T057 [US2] Implementar validador de payload remoto em lib/services/question_payload_validator_service.dart
- [ ] T058 [US2] Implementar repositorio de sincronizacao com merge idempotente em lib/data/repositories/sync_repository_impl.dart
- [ ] T059 [US2] Implementar caso de uso de sincronizacao silenciosa em lib/domain/usecases/sync_questions.dart
- [ ] T060 [US2] Implementar agendamento de sync 24h e on-level-up em lib/services/background_task_service.dart
- [ ] T061 [US2] Implementar orquestracao silenciosa de sync em lib/services/sync_service.dart
- [ ] T062 [US2] Integrar trigger de sync no fluxo de level-up em lib/presentation/bloc/game_bloc.dart
- [ ] T063 [US2] Implementar estado de sincronizacao para UI sem modal em lib/presentation/bloc/sincronizacao_bloc.dart
- [ ] T064 [US2] Registrar logs estruturados de falha/retry de sync em lib/services/logging_service.dart

**Checkpoint**: US2 funcional e testavel isoladamente.

---

## Phase 5: User Story 3 - Interface em Multiplos Idiomas (Priority: P3)

**Goal**: Garantir UI em PT-BR/EN/IT com fallback automatico para PT-BR e troca de idioma em runtime.

**Independent Test**: Mudar idioma e validar atualizacao da UI/contexto; quando chave faltar, fallback para PT-BR sem erro.

### Tests for User Story 3

- [ ] T065 [P] [US3] Criar teste de fallback de traducao para PT-BR em test/unit/localization/fallback_test.dart
- [ ] T066 [P] [US3] Criar teste de widget para troca de idioma em runtime em test/widget/settings_language_switch_test.dart
- [ ] T067 [P] [US3] Criar teste de integracao da UI multilíngue em test/integration/localization_test.dart

### Implementation for User Story 3

- [ ] T068 [US3] Implementar configuracao central de localizacao e fallback em lib/config/localization.dart
- [ ] T069 [US3] Implementar persistencia de idioma preferido em lib/data/datasources/local/configuracao_idioma_local_source.dart
- [ ] T070 [US3] Implementar caso de uso de mudanca/recuperacao de idioma em lib/domain/usecases/change_language.dart
- [ ] T071 [US3] Implementar pagina de configuracoes com seletor de idioma em lib/presentation/pages/settings_page.dart
- [ ] T072 [P] [US3] Atualizar traducoes de gameplay e Game Over em assets/locales/en.json
- [ ] T073 [P] [US3] Atualizar traducoes de gameplay e Game Over em assets/locales/it.json
- [ ] T074 [US3] Implementar widget de contexto educativo multilíngue em lib/presentation/widgets/contexto_educativo.dart
- [ ] T075 [US3] Integrar mudanca de locale no bootstrap da app em lib/main.dart

**Checkpoint**: US3 funcional e testavel isoladamente.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Objetivo**: Fechamento de qualidade, performance, acessibilidade e documentacao.

- [ ] T076 [P] Validar cobertura >= 90% das regras de jogo em test/unit/domain/
- [ ] T077 Executar suite completa de testes e corrigir regressao em test/integration/offline_resume_test.dart
- [ ] T078 [P] Ajustar acessibilidade da tela principal em lib/presentation/pages/game_page.dart
- [ ] T079 [P] Ajustar acessibilidade da tela de Game Over em lib/presentation/pages/game_over_page.dart
- [ ] T080 Validar regra de sincronizacao (24h + level-up) e banda em lib/services/sync_service.dart
- [ ] T081 [P] Atualizar documentacao tecnica do projeto em ./README.md
- [ ] T082 Validar quickstart fim-a-fim em specs/001-quizverse-forca/quickstart.md
- [ ] T083 [P] Criar benchmark de fallback de localizacao (p95 <= 10ms) em test/integration/localization_performance_test.dart
- [ ] T084 [P] Criar benchmark de persistencia de progresso (p95 <= 100ms) em test/integration/persistence_latency_test.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- Phase 1 (Setup): sem dependencias.
- Phase 2 (Foundational): depende da Phase 1 e bloqueia todas as stories.
- Phase 3 (US1): depende da Phase 2.
- Phase 4 (US2): depende da Phase 2 e integra com fluxo de US1.
- Phase 5 (US3): depende da Phase 2.
- Phase 6 (Polish): depende das stories selecionadas concluidas.

### User Story Dependencies

- US1: independente apos fundacao e define MVP.
- US2: independente apos fundacao, com integracao no fluxo de level-up.
- US3: independente apos fundacao, sem bloquear US1/US2.

### Parallel Opportunities

- Setup: T002-T004, T006-T008 em paralelo.
- Foundational: T010-T014, T016-T022, T024-T026, T028-T029 em paralelo.
- US1: T031-T035 e T042-T047, T051 em paralelo.
- US2: T052-T055 em paralelo.
- US3: T065-T067 e T072-T073 em paralelo.
- Polish: T076, T078, T079, T081, T083, T084 em paralelo.

---

## Parallel Example: User Story 1

```bash
# Testes US1 em paralelo
Task: "T031 em test/unit/domain/usecases/advance_level_test.dart"
Task: "T032 em test/unit/domain/usecases/game_over_test.dart"
Task: "T033 em test/unit/domain/usecases/continue_game_test.dart"
Task: "T035 em test/widget/game_page_test.dart"

# Widgets US1 em paralelo
Task: "T045 em lib/presentation/widgets/palavras_display.dart"
Task: "T046 em lib/presentation/widgets/error_bar.dart"
Task: "T047 em lib/presentation/widgets/letra_button.dart"
```

---

## Implementation Strategy

### MVP First (US1)

1. Concluir Phase 1 (Setup)
2. Concluir Phase 2 (Foundational)
3. Concluir Phase 3 (US1)
4. Validar criterios independentes da US1

### Incremental Delivery

1. Entregar base: Setup + Foundational
2. Entregar US1 e validar offline
3. Entregar US2 e validar resiliencia de sync
4. Entregar US3 e validar fallback de localizacao
5. Fechar com Phase 6

### Parallel Team Strategy

1. Time conclui Setup + Foundational
2. Dev A: US1
3. Dev B: US2
4. Dev C: US3
5. Time converge para Polish

---

## Total de Tarefas

- Phase 1: 8 tarefas
- Phase 2: 22 tarefas
- Phase 3 (US1): 21 tarefas
- Phase 4 (US2): 13 tarefas
- Phase 5 (US3): 11 tarefas
- Phase 6: 9 tarefas

**Total**: 84 tarefas (T001-T084)

---

## Validacao de Formato

- Todos os itens estao no formato `- [ ] Txxx [P?] [US?] descricao com caminho de arquivo`.
- Labels `[US1]`, `[US2]`, `[US3]` aparecem apenas nas fases de user story.
- Fases Setup/Foundational/Polish sem label de story.
