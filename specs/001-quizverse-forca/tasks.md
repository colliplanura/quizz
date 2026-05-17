# Tasks: QuizVerse: Forca

> Tarefas em Portugues (Brasil), orientadas por historias de usuario e prontas
> para execucao incremental.

**Input**: Artefatos de design em `/specs/001-quizverse-forca/`

**Prerequisites**: plan.md (obrigatorio), spec.md (obrigatorio), research.md,
data-model.md, contracts/api-github.md, quickstart.md

**Tests**: Incluidos porque a especificacao exige cobertura automatizada das
regras de jogo (SC-007, NFR-006).

**Organization**: Tarefas agrupadas por historia de usuario (US1, US2, US3)
para permitir implementacao e validacao independentes.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Pode rodar em paralelo (arquivos diferentes, sem dependencia direta)
- **[Story]**: Historia de usuario (US1, US2, US3)
- Todas as tarefas incluem caminho de arquivo explicito

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicializar projeto Flutter e base tecnica compartilhada.

- [X] T001 Criar app Flutter base e estrutura Clean Architecture em lib/ e test/ via lib/main.dart
- [X] T002 Configurar dependencias no pubspec em pubspec.yaml
- [X] T003 [P] Configurar analise estaticas e regras de lint em analysis_options.yaml
- [X] T004 [P] Configurar assets iniciais de localizacao, icones e pacote minimo de perguntas embarcado em pubspec.yaml
- [X] T005 Criar bootstrap de aplicacao com easy_localization e tema base em lib/main.dart
- [X] T006 [P] Criar arquivos de traducao base pt_BR/en/it em assets/locales/pt_BR.json
- [X] T007 [P] Criar arquivos de traducao base pt_BR/en/it em assets/locales/en.json
- [X] T008 [P] Criar arquivos de traducao base pt_BR/en/it em assets/locales/it.json

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Infraestrutura obrigatoria para habilitar todas as historias.

**CRITICAL**: Nenhuma historia deve iniciar antes desta fase terminar.

- [X] T009 Implementar constantes globais de regras (10 acertos, 3 erros, estado inicial L1/S0/T1) em lib/utils/constants.dart
- [X] T010 [P] Criar entidades de dominio Pergunta/Progresso/Partida/Trofeu/ConfiguracaoIdioma em lib/domain/entities/pergunta.dart
- [X] T011 [P] Criar entidades de dominio Pergunta/Progresso/Partida/Trofeu/ConfiguracaoIdioma em lib/domain/entities/progresso.dart
- [X] T012 [P] Criar entidades de dominio Pergunta/Progresso/Partida/Trofeu/ConfiguracaoIdioma em lib/domain/entities/partida.dart
- [X] T013 [P] Criar entidades de dominio Pergunta/Progresso/Partida/Trofeu/ConfiguracaoIdioma em lib/domain/entities/trofeu.dart
- [X] T014 [P] Criar entidades de dominio Pergunta/Progresso/Partida/Trofeu/ConfiguracaoIdioma em lib/domain/entities/configuracao_idioma.dart
- [X] T015 Definir contratos de repositorio de dominio para perguntas, progresso e sincronizacao em lib/domain/repositories/pergunta_repository.dart
- [X] T016 [P] Definir contratos de repositorio de dominio para perguntas, progresso e sincronizacao em lib/domain/repositories/progresso_repository.dart
- [X] T017 [P] Definir contratos de repositorio de dominio para perguntas, progresso e sincronizacao em lib/domain/repositories/sync_repository.dart
- [X] T018 Implementar modelos de dados e mapeamentos domain<->data com contexto_historico por idioma (pt_BR/en/it) em lib/data/models/pergunta_model.dart
- [X] T019 [P] Implementar modelos de dados e mapeamentos domain<->data em lib/data/models/progresso_model.dart
- [X] T020 [P] Implementar modelos de dados e mapeamentos domain<->data em lib/data/models/partida_model.dart
- [X] T021 [P] Implementar modelos de dados e mapeamentos domain<->data em lib/data/models/trofeu_model.dart
- [X] T022 [P] Implementar modelos de dados e mapeamentos domain<->data em lib/data/models/configuracao_idioma_model.dart
- [X] T023 Implementar adaptadores Hive e abertura de boxes em lib/data/datasources/local/hive_adapter.dart
- [X] T024 [P] Implementar datasource local de perguntas com carga inicial de pacote embarcado no primeiro uso offline em lib/data/datasources/local/pergunta_local_source.dart
- [X] T025 [P] Implementar datasource local de progresso/partida em lib/data/datasources/local/progresso_local_source.dart
- [X] T026 [P] Implementar datasource local de trofeus e idioma em lib/data/datasources/local/trofeu_local_source.dart
- [X] T027 Implementar repositorios concretos com tolerancia a falhas locais em lib/data/repositories/pergunta_repository_impl.dart
- [X] T028 [P] Implementar repositorios concretos com tolerancia a falhas locais em lib/data/repositories/progresso_repository_impl.dart
- [X] T029 [P] Implementar helper de validacao e normalizacao de resposta/contexto com fallback pt_BR para contexto_historico em lib/utils/validators.dart
- [X] T030 Configurar servico de logs locais para sync e validacao de dados em lib/services/logging_service.dart

**Checkpoint**: Fundacao pronta; historias podem iniciar.

---

## Phase 3: User Story 1 - Jogar Forca Offline (Priority: P1) 🎯 MVP

**Goal**: Entregar gameplay completo offline com progressao, Game Over,
continue/restart e restauracao de partida.

**Independent Test**: Sem internet, iniciar jogo, responder perguntas,
atingir nivel novo, acionar Game Over com 3 erros, continuar com trofeu,
reiniciar, fechar e reabrir app mantendo estado esperado.

### Tests for User Story 1

- [X] T031 [P] [US1] Criar testes unitarios de regras de progressao (10 acertos e level-up) em test/unit/domain/usecases/advance_level_test.dart
- [X] T032 [P] [US1] Criar testes unitarios de regras de erro e Game Over (3 erros) em test/unit/domain/usecases/game_over_test.dart
- [X] T033 [P] [US1] Criar testes unitarios de continue/restart, consumo de trofeu e bloqueio de continuar com 0 trofeus em test/unit/domain/usecases/continue_game_test.dart
- [X] T034 [P] [US1] Criar teste de restauracao de partida apos relaunch em test/integration/offline_resume_test.dart
- [X] T035 [P] [US1] Criar teste de widget para fluxo de tela de jogo offline incluindo primeiro uso sem rede com pacote embarcado em test/widget/game_page_test.dart

### Implementation for User Story 1

- [X] T036 [US1] Implementar caso de uso iniciar/restaurar partida offline em lib/domain/usecases/play_game.dart
- [X] T037 [US1] Implementar caso de uso de validacao de resposta/letra e atualizacao de estado em lib/domain/usecases/check_answer.dart
- [X] T038 [US1] Implementar caso de uso de level-up e reset de streak do nivel em lib/domain/usecases/advance_level.dart
- [X] T039 [US1] Implementar caso de uso de Game Over com opcoes continuar/reiniciar em lib/domain/usecases/game_over.dart
- [X] T040 [US1] Implementar caso de uso continuar partida com custo de 1 trofeu em lib/domain/usecases/continue_game.dart
- [X] T041 [US1] Implementar GameBloc/State/Event para ciclo completo da partida em lib/presentation/bloc/game_bloc.dart
- [X] T042 [P] [US1] Definir eventos de jogo (start, guess, continue, restart, restore) em lib/presentation/bloc/game_event.dart
- [X] T043 [P] [US1] Definir estados de jogo (loading, running, levelUp, gameOver) em lib/presentation/bloc/game_state.dart
- [X] T044 [US1] Implementar tela principal de jogo com barra de erros animada em lib/presentation/pages/game_page.dart
- [X] T045 [P] [US1] Implementar componente de palavra mascarada e letras adivinhadas em lib/presentation/widgets/palavras_display.dart
- [X] T046 [P] [US1] Implementar componente animado de barra de erros 0-3 em lib/presentation/widgets/error_bar.dart
- [X] T047 [P] [US1] Implementar grade de botoes de letras com estados habilitado/desabilitado em lib/presentation/widgets/letra_button.dart
- [X] T048 [US1] Implementar tela de Game Over com continuar desabilitado e mensagem explicativa quando trofeus = 0 em lib/presentation/pages/game_over_page.dart
- [X] T049 [US1] Implementar exibicao de trofeus, nivel e pontuacao em tempo real em lib/presentation/widgets/trophy_display.dart
- [X] T050 [US1] Integrar persistencia de partida/progresso em cada transicao de estado em lib/services/game_state_persistence_service.dart
- [X] T086 [P] [US1] Implementar widget de animacao de celebracao de level-up (FR-010) em lib/presentation/widgets/level_up_celebration.dart

**Checkpoint**: US1 funcional e validavel isoladamente.

---

## Phase 4: User Story 2 - Sincronizar Perguntas do GitHub (Priority: P2)

**Goal**: Sincronizar perguntas em background (24h ou level-up) sem bloquear o
jogo e sem corromper progresso local.

**Independent Test**: Durante partida ativa, executar sync com sucesso e com
falha; jogo continua responsivo, progresso permanece intacto, perguntas invalidas
sao rejeitadas e logadas.

### Tests for User Story 2

- [X] T051 [P] [US2] Criar teste de contrato para schema de perguntas GitHub com contexto_historico por idioma em test/unit/data/datasources/github_contract_test.dart
- [X] T052 [P] [US2] Criar teste unitario de idempotencia de sync por hash e Last-Modified em test/unit/domain/usecases/sync_questions_test.dart
- [X] T053 [P] [US2] Criar teste de integracao para falha de rede e payload 100% invalido sem corrupcao de progresso em test/integration/sync_failure_resilience_test.dart
- [X] T054 [P] [US2] Criar teste de integracao para trigger de sync em level-up sem bloquear UI em test/integration/sync_on_level_up_test.dart

### Implementation for User Story 2

- [X] T055 [US2] Implementar client remoto GitHub para perguntas.json com timeout/retry em lib/data/datasources/remote/github_remote_source.dart
- [X] T056 [US2] Implementar validador de payload remoto com descarte de entradas malformadas e tratamento de payload 100% invalido mantendo cache local em lib/services/question_payload_validator_service.dart
- [X] T057 [US2] Implementar repositorio de sincronizacao com merge aditivo e idempotente em lib/data/repositories/sync_repository_impl.dart
- [X] T058 [US2] Implementar caso de uso de sincronizacao silenciosa em lib/domain/usecases/sync_questions.dart
- [X] T059 [US2] Implementar servico de agendamento de sync por 24h e on-level-up em lib/services/background_task_service.dart
- [X] T060 [US2] Implementar orquestracao de sync e observabilidade minima garantindo fluxo silencioso sem alerta modal em falhas de payload invalido em lib/services/sync_service.dart
- [X] T061 [US2] Integrar disparo de sync no fluxo de level-up sem bloquear celebracao em lib/presentation/bloc/game_bloc.dart
- [X] T062 [US2] Implementar estado de sincronizacao silenciosa para UI sem loading modal em lib/presentation/bloc/sincronizacao_bloc.dart
- [X] T063 [US2] Registrar logs estruturados de falhas e retries de sincronizacao em lib/services/logging_service.dart

**Checkpoint**: US2 funcional e validavel isoladamente.

---

## Phase 5: User Story 3 - Interface em Multiplos Idiomas (Priority: P3)

**Goal**: Entregar UI em PT-BR/EN/IT com fallback automatico para PT-BR e
troca de idioma sem reiniciar app.

**Independent Test**: Alterar idioma e confirmar textos da UI/contexto
educativo atualizados; quando chave faltar, app usa PT-BR sem erro.

### Tests for User Story 3

- [X] T064 [P] [US3] Criar teste de fallback de chave ausente para PT-BR em test/unit/localization/fallback_test.dart
- [X] T065 [P] [US3] Criar teste de widget para troca de idioma em runtime em test/widget/settings_language_switch_test.dart
- [X] T066 [P] [US3] Criar teste de integracao de localizacao completa da UI em test/integration/localization_test.dart

### Implementation for User Story 3

- [X] T067 [US3] Implementar configuracao central de localizacao e fallback pt_BR em lib/config/localization.dart
- [X] T068 [US3] Implementar persistencia de idioma preferido localmente em lib/data/datasources/local/configuracao_idioma_local_source.dart
- [X] T069 [US3] Implementar caso de uso de alteracao e recuperacao de idioma em lib/domain/usecases/change_language.dart
- [X] T070 [US3] Implementar pagina de configuracoes com seletor de idioma em lib/presentation/pages/settings_page.dart
- [X] T071 [P] [US3] Traduzir textos de gameplay e game over em assets/locales/en.json
- [X] T072 [P] [US3] Traduzir textos de gameplay e game over em assets/locales/it.json
- [X] T073 [US3] Implementar widget de contexto educativo com suporte a estrutura por idioma e fallback para pt_BR em lib/presentation/widgets/contexto_educativo.dart
- [X] T074 [US3] Integrar notificacao de mudanca de locale no estado global da app em lib/main.dart

**Checkpoint**: US3 funcional e validavel isoladamente.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Qualidade final, performance, acessibilidade e documentacao.

- [X] T075 [P] Validar cobertura >= 90% das regras de jogo e gerar relatorio em test/unit/domain/
- [X] T076 Executar suite completa de testes (unit/widget/integration) e corrigir regressao em test/
- [X] T077 [P] Implementar ajustes de acessibilidade (contraste, semantics, labels) em lib/presentation/pages/game_page.dart
- [X] T078 [P] Implementar ajustes de acessibilidade (contraste, semantics, labels) em lib/presentation/pages/game_over_page.dart
- [X] T079 Otimizar latencia de carregamento inicial e troca de pergunta (<1s) em lib/presentation/bloc/game_bloc.dart
- [X] T080 Validar regras de sincronizacao (24h + level-up) e banda <= 5MB por requisicao em lib/services/sync_service.dart
- [X] T081 [P] Atualizar documentacao tecnica e guia de execucao em README.md
- [X] T082 Validar quickstart fim-a-fim e alinhar instrucoes com implementacao real em specs/001-quizverse-forca/quickstart.md
- [X] T083 [P] Escrever testes de acessibilidade (widget test) validando Semantics labels, contraste e foco em lib/presentation/pages/game_page.dart (NFR-005)
- [X] T084 [P] Escrever testes de acessibilidade (widget test) validando Semantics labels, contraste e foco em lib/presentation/pages/game_over_page.dart (NFR-005)
- [X] T085 Validar conformidade de seguranca: HTTPS-only, sem logs de dados pessoais, dependencias sem CVEs criticas em pubspec.yaml (NFR-010)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: sem dependencia
- **Phase 2 (Foundational)**: depende da Phase 1 e bloqueia historias
- **Phase 3 (US1)**: depende da Phase 2
- **Phase 4 (US2)**: depende da Phase 2 e integra com fluxo de US1
- **Phase 5 (US3)**: depende da Phase 2
- **Phase 6 (Polish)**: depende das historias concluídas

### User Story Dependencies

- **US1 (P1)**: primeira entrega MVP, independente apos fundacao
- **US2 (P2)**: independente apos fundacao, integra trigger no fluxo de US1
- **US3 (P3)**: independente apos fundacao, sem bloqueio tecnico de US1/US2

### Dependency Graph (High Level)

- Setup -> Foundational -> US1 -> Polish
- Setup -> Foundational -> US2 -> Polish
- Setup -> Foundational -> US3 -> Polish

### Parallel Opportunities

- Setup: T003, T004, T006, T007, T008 em paralelo
- Foundational: T010-T014, T016-T017, T019-T022, T024-T026, T028-T029 em paralelo
- US1: T031-T035 e T042-T047 em paralelo
- US2: T051-T054 em paralelo
- US3: T064-T066 e T071-T072 em paralelo
- Polish: T075, T077, T078, T081, T083, T084 em paralelo

---

## Parallel Example: User Story 1

```bash
# Testes US1 em paralelo
T031 advance_level_test.dart
T032 game_over_test.dart
T033 continue_game_test.dart
T035 game_page_test.dart

# Widgets US1 em paralelo
T045 palavras_display.dart
T046 error_bar.dart
T047 letra_button.dart
```

---

## Implementation Strategy

### MVP First (US1)

1. Concluir Phase 1 (Setup)
2. Concluir Phase 2 (Foundational)
3. Concluir Phase 3 (US1)
4. Validar criterios independentes da US1 (offline completo)
5. Congelar MVP e preparar demo

### Incremental Delivery

1. Entregar MVP com US1
2. Adicionar US2 (sync silencioso) e validar resiliencia
3. Adicionar US3 (multiplos idiomas) e validar fallback
4. Fechar com Phase 6 (qualidade, acessibilidade, performance)

### Suggested MVP Scope

- **MVP sugerido**: Phase 1 + Phase 2 + Phase 3 (US1)

---

## Validation Checklist

- [x] Todas as tarefas seguem formato `- [ ] T### [P?] [US?] Descricao com caminho`
- [x] IDs sequenciais de T001 a T086
- [x] Fases organizadas por Setup, Foundational, US1, US2, US3, Polish
- [x] Cada historia possui criterio de teste independente
- [x] Tarefas paralelizaveis marcadas com [P]