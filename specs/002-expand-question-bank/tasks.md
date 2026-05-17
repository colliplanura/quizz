---
description: "Task list for 002-expand-question-bank feature implementation"
---

# Tasks: Expansão da Base de Perguntas

> Tarefas em Português (Brasil), organizadas por user story para implementação e testes independentes.

**Input**: Design documents from `/specs/002-expand-question-bank/`

**Spec**: [spec.md](spec.md)  
**Plan**: [plan.md](plan.md)  
**Data Model**: [data-model.md](data-model.md)  
**Contract**: [contracts/question-catalog.md](contracts/question-catalog.md)  
**Research**: [research.md](research.md)  

**Total Tasks**: 56  
**Parallelizable**: 22 tasks marked [P]  
**By User Story**: US1 (15 tasks), US2 (14 tasks), US3 (11 tasks)

---

## Phase 1: Setup (Infraestrutura Compartilhada)

**Propósito**: Inicialização do projeto e estrutura básica

- [X] T001 Criar estrutura de diretórios conforme plan.md (lib/data, lib/domain, lib/presentation, test/)
- [X] T002 Validar dependências Flutter 3.x + Dart 3.11.x em pubspec.yaml (hive, hive_flutter, flutter_bloc ou riverpod)
- [ ] T003 [P] Configurar análise estática (dart analyze) e formatação (dart format) com CI
- [X] T004 Criador modelo de entities base em lib/domain/entities (Pergunta, Historico, etc.)

---

## Phase 2: Foundational (Pré-Requisitos Bloqueadores)

**Propósito**: Infraestrutura crítica que DEVE estar completa antes de qualquer user story

**⚠️ CRÍTICO**: Nenhum trabalho de user story pode iniciar até esta fase estar completa

- [X] T005 [P] Implementar ConfiguracaoPartida em lib/domain/entities/configuracao_partida.dart com maxErrosConsecutivos=5 e janelaAntiRepeticaoHoras=2
- [X] T006 [P] Criar PerguntaCatalogo entity em lib/domain/entities/pergunta_catalogo.dart com id, enunciado, respostaNormalizada, respostaExibicao, categoria, dificuldade (1-10), contexto
- [X] T007 [P] Criar HistoricoPerguntaRespondida entity em lib/domain/entities/historico_pergunta_respondida.dart com perguntaId, respondidaEm, jogadorId
- [X] T008 [P] Criar PerfilDistribuicaoDificuldade entity em lib/domain/entities/perfil_distribuicao_dificuldade.dart com nivelJogo, pesosPorDificuldade (1-10), versaoPerfil
- [X] T009 [P] Implementar Hive box setup para PerguntaCatalogo, HistoricoPerguntaRespondida e ConfiguracaoPartida em lib/data/datasources/local/hive_initialization.dart
- [ ] T010 [P] Criar adapters Hive para todas as 4 entities (TypeAdapter<T>) em lib/data/datasources/local/hive_adapters/
- [ ] T011 [P] Implementar PerguntaCatalogoLocalDataSource (CRUD) em lib/data/datasources/local/pergunta_catalogo_local_datasource.dart
- [X] T012 [P] Implementar HistoricoPerguntaLocalDataSource (add, list, clearOlderThan) em lib/data/datasources/local/historico_pergunta_local_datasource.dart
- [ ] T013 [P] Implementar ConfiguracaoPartidaLocalDataSource (get/save) em lib/data/datasources/local/configuracao_partida_local_datasource.dart
- [ ] T014 [P] Implementar PerfilDistribuicaoRepository com repositório Hive em lib/data/repositories/perfil_distribuicao_repository.dart
- [ ] T015 [P] Configurar localizações (easy_localization) para PT-BR/EN/IT com PT-BR como fallback em lib/l10n/
- [ ] T016 [P] Implementar GitHub sync de catálogo JSON (http 1.x) com check de 24h e level-up em lib/domain/usecases/sincronizar_catalogo.dart
- [X] T017 [P] Setup constants.dart com maxErrosConsecutivos=5 e janelaAntiRepeticaoHoras=2 em lib/utils/constants.dart
- [X] T018 Implementar gerenciador de estado (BLoC 8.x ou Riverpod 2.x) para jogo em lib/presentation/bloc/game_bloc.dart ou equivalent

**Checkpoint**: Infraestrutura pronta - implementação de user stories pode começar em paralelo

---

## Phase 3: User Story 1 - Base Inicial com 1000 Perguntas (Priority: P1) 🎯 MVP

**Goal**: Providenciar base inicial robusta e validada com 1000 perguntas únicas, variadas e classificadas por nível de dificuldade 1-10.

**Independent Test**: Validar que a base inicial contém exatamente 1000 perguntas únicas e válidas, cada uma com dificuldade entre 1 e 10, distribuídas em no mínimo 10 categorias com pelo menos 50 perguntas por categoria.

### Tests para User Story 1 ⚠️

- [X] T019 [P] [US1] Teste unitário para validação de catálogo (1000 perguntas, 10+ categorias) em test/unit/data/datasources/test_pergunta_catalogo_validation.dart
- [X] T020 [P] [US1] Teste unitário para unicidade de pergunta IDs em test/unit/data/datasources/test_pergunta_id_uniqueness.dart
- [X] T021 [P] [US1] Teste unitário para intervalo de dificuldade (1-10) em test/unit/data/datasources/test_dificuldade_range.dart
- [X] T022 [P] [US1] Teste de performance para carregamento do catálogo (p95 < 200ms) em test/integration/test_catalog_load_performance.dart

### Implementação para User Story 1

- [X] T023 [P] [US1] Gerar JSON com 1000 perguntas válidas (assets/data/perguntas_inicial.json) com 10+ categorias, 50+ por categoria, distribuição equilibrada por dificuldade
- [X] T024 [P] [US1] Criar AssetCatalogoLocalDataSource para carregar perguntas_inicial.json em lib/data/datasources/local/asset_catalogo_local_datasource.dart
- [X] T025 [US1] Implementar CatalogoRepository que combina asset + Hive em lib/data/repositories/catalogo_repository.dart (depende T023, T024)
- [X] T026 [US1] Implementar ListarCatalogoUseCase em lib/domain/usecases/listar_catalogo.dart (depende T025)
- [X] T027 [P] [US1] Implementar ValidarCatalogoUseCase (1000 únicas, 10+ categorias, 50+ por cat) em lib/domain/usecases/validar_catalogo.dart
- [X] T028 [P] [US1] Criar tela CatalogoScreen em lib/presentation/pages/catalogo_screen.dart (exibição de estatísticas: total, categorias, distribuição)
- [X] T029 [P] [US1] Implementar CatalogoBLoC em lib/presentation/bloc/catalogo_bloc.dart com eventos Load, Validate
- [X] T030 [US1] Criar testes de integração para fluxo completo (carregar + validar) em test/integration/test_catalogo_flow.dart (depende T019, T027)

---

## Phase 4: User Story 2 - Sorteio Adaptativo por Nível (Priority: P1)

**Goal**: Implementar seleção de perguntas com distribuição ponderada progressiva por nível de jogo, favorecendo dificuldades baixas em níveis iniciais e altas em avançados.

**Independent Test**: Simular 300+ sorteios por nível (baixo/médio/alto) e validar que predominância de dificuldades respeita curva esperada para cada fase (p95 >= 70% de conformidade com faixa esperada).

### Tests para User Story 2 ⚠️

- [X] T031 [P] [US2] Teste unitário de distribuição para nível baixo (1-3 predominantes) em test/unit/domain/usecases/test_selecionar_pergunta_nivel_baixo.dart
- [X] T032 [P] [US2] Teste unitário de distribuição para nível médio em test/unit/domain/usecases/test_selecionar_pergunta_nivel_medio.dart
- [X] T033 [P] [US2] Teste unitário de distribuição para nível alto (8-10 predominantes) em test/unit/domain/usecases/test_selecionar_pergunta_nivel_alto.dart
- [X] T034 [P] [US2] Teste de aleatoriedade (300 sorteios repetidos) em test/unit/domain/usecases/test_selecionar_pergunta_randomness.dart

### Implementação para User Story 2

- [X] T035 [P] [US2] Criar matriz de pesos por nível em lib/domain/entities/perfil_distribuicao_dificuldade.dart (níveis 1-10, pesos 1-10 cada)
- [X] T036 [US2] Implementar SelecionarPerguntaUseCase com lógica de distribuição ponderada em lib/domain/usecases/selecionar_pergunta.dart (depende T035)
- [X] T037 [P] [US2] Implementar CalculadorDistribuicaoUseCase (cálculo de pesos residuais) em lib/domain/usecases/calculador_distribuicao.dart
- [X] T038 [P] [US2] Implementar WeightedRandomSelector (utilidade de sorteio ponderado) em lib/domain/utils/weighted_random_selector.dart
- [X] T039 [US2] Integrar SelecionarPerguntaUseCase no GameBLoC em lib/presentation/bloc/game_bloc.dart (depende T036)
- [X] T040 [P] [US2] Criar testes de integração para sorteio e exibição em test/integration/test_selecao_pergunta_integracao.dart (depende T031-T034)
- [X] T041 [US2] Validar curva de dificuldade em progresso de nível (benchmark) em test/benchmark/benchmark_distribuicao.dart (depende T032)

---

## Phase 5: User Story 3 - Anti-Repetição e Novo Limite de Erros (Priority: P2)

**Goal**: Implementar regra de anti-repetição por 2 horas (wall-clock) e ajustar game over para 5 erros consecutivos, garantindo novidade e acessibilidade.

**Independent Test**: Em sessão contínua, verificar que pergunta respondida não reaparece em 2h de wall-clock e que game over ocorre apenas no 5º erro consecutivo.

### Tests para User Story 3 ⚠️

- [X] T042 [P] [US3] Teste unitário de anti-repetição (pergunta inelegível em 2h) em test/unit/domain/usecases/test_anti_repeticao.dart
- [X] T043 [P] [US3] Teste unitário de fallback (pool vazio -> reset histórico) em test/unit/domain/usecases/test_anti_repeticao_fallback.dart
- [X] T044 [P] [US3] Teste unitário de game over no 5º erro em test/unit/domain/usecases/test_game_over_5_erros.dart
- [X] T045 [P] [US3] Teste de integração com wall-clock simulado (2h+1min) em test/integration/test_wall_clock_anti_repeticao.dart

### Implementação para User Story 3

- [X] T046 [US3] Implementar AntiRepeticaoUseCase (elegibilidade por 2h wall-clock + fallback) em lib/domain/usecases/anti_repeticao_usecase.dart (depende T036, T012)
- [X] T047 [P] [US3] Implementar GameOverUseCase (5 erros consecutivos) em lib/domain/usecases/game_over_usecase.dart
- [X] T048 [US3] Integrar anti-repetição e game over no gameplay flow (GameBLoC + HistoricoRepository) em lib/presentation/bloc/game_bloc.dart (depende T046, T047)

---

## Phase 6: Polish & Cross-Cutting Concerns

**Propósito**: Refinamento final, validação de compatibilidade e documentação

- [X] T049 [P] Executar testes unitários completos (flutter test) para todas as 48 tarefas
- [X] T050 [P] Executar testes de integração com app real
- [X] T051 Validar compatibilidade com regras existentes (pontuação, progressão, continuidade de partida)
- [X] T052 [P] Gerar relatório de performance (p95 sorteio + carregamento) vs. meta (200ms)
- [X] T053 [P] Validar conformidade com Constitution v2.0.0 (Princípios I-V)
- [X] T054 Criar documentação de uso em PT-BR (quickstart.md update com exemplos de integração)
- [X] T055 [P] Executar flutter analyze e corrigir warnings
- [X] T056 Abrir pull request com branch 002-expand-question-bank-clean, listar todas as 56 tarefas completas

---

## Dependency Graph & Execution Order

### Phase 1 (Setup)
- **Serial path**: T001 → T002 → T003 → T004
- **Duration**: ~30 min

### Phase 2 (Foundational - Blocking)
- **Parallel blocks**:
  - Block A (Entities): T005, T006, T007, T008 parallel → T009, T010 parallel → T011, T012, T013 parallel
  - Block B (Storage): T014, T015, T016, T017 parallel
  - Block C (State): T018 (depends on Block A + B complete)
- **Critical path**: T001 → T002 → (T006 + T007 + T008) → T009 → T010 → T011 → T018
- **Duration**: ~2-3h

### Phase 3 (US1 - Base Inicial)
- **Parallel**: T019, T020, T021, T022 (tests) + T023, T024 (data generation)
- **Serial**: T023 → T025 → T026 + T027
- **Integration**: T028, T029 parallel → T030
- **Duration**: ~3-4h

### Phase 4 (US2 - Sorteio Adaptativo)
- **Parallel tests**: T031, T032, T033, T034
- **Parallel implementation**: T035, T037, T038 → T036 → T039
- **Integration**: T040, T041 (depends on T036)
- **Duration**: ~3-4h

### Phase 5 (US3 - Anti-Repetição)
- **Parallel tests**: T042, T043, T044, T045
- **Serial**: T046 → T047 → T048
- **Duration**: ~2-3h

### Phase 6 (Polish)
- **Parallel**: T049, T050, T052, T053, T055
- **Serial**: T051 → T054 → T056
- **Duration**: ~1-2h

---

## MVP Scope (Minimum Viable Product)

**Phases 1-3** deliver the MVP:
- ✅ 1000-question catalog loaded and validated (T023-T030)
- ✅ Basic question selection working (minimal difficulty preference)
- ✅ Foundation for state management and persistence

**Add Phases 4-5 for full feature**:
- ✅ Weighted difficulty distribution per level (T036-T041)
- ✅ Anti-repetition window enforcement (T046-T048)
- ✅ 5-error game over rule

---

## Validation Checklist

- [ ] All 56 tasks follow format: `- [ ] [ID] [P?] [Story?] Description with file path`
- [ ] File paths are absolute or workspace-relative (lib/, test/, assets/)
- [ ] Each task is atomic and independently executable
- [ ] Tests are marked [P] where applicable (independent parallelization)
- [ ] User Story labels [US1], [US2], [US3] applied correctly
- [ ] Dependencies are documented in Dependency Graph
- [ ] Total task count: 56 (T001-T056)
- [ ] Parallelizable count: 22 [P] tasks

---

## Implementation Notes

1. **Localization** (T015): Use `easy_localization` with JSON resources in `lib/l10n/` for PT-BR/EN/IT
2. **Hive Persistence** (T009-T013): Box names: `pergunta_catalogo_box`, `historico_pergunta_box`, `configuracao_partida_box`
3. **Performance Goals** (T022, T041): Benchmark targets in `plan.md` - sorteio + carregamento ≤ 200ms p95
4. **Constitution Check** (T053): Validate all 5 principles from `constitution.md` v2.0.0
5. **Testing Strategy**: Write tests first (T019-T022, T031-T034, T042-T045), then implementation
6. **Git Workflow**: Branch `002-expand-question-bank-clean`, commit per phase completion (T056 for PR)
