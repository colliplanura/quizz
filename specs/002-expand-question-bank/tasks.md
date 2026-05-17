# Tasks: Expansão da Base de Perguntas

> Tarefas em Português (Brasil), com descrições claras, curtas e fáceis de
> executar.

**Input**: Design documents from `/specs/002-expand-question-bank/`

**Feature**: 002-expand-question-bank  
**Branch**: 002-create-new-spec  
**Status**: Ready for implementation

---

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Pode executar em paralelo (arquivos diferentes, sem dependências)
- **[Story]**: User story que a tarefa pertence (US1, US2, US3)
- Caminhos de arquivo exactos nas descrições

---

## Phase 1: Setup (Infraestrutura Compartilhada)

**Objetivo**: Inicialização básica da feature dentro do projeto existente

- [ ] T001 Criar estrutura de diretórios para feature 002 em lib/ e test/
- [ ] T002 [P] Criar classes base para entidades do catálogo em lib/domain/entities/pergunta.dart
- [ ] T003 [P] Criar enums para categorias e dificuldade em lib/domain/entities/pergunta.dart
- [ ] T004 Criar modelo de dados local para Hive em lib/data/models/pergunta_model.dart
- [ ] T005 Criar adaptador Hive para PerguntaModel em lib/data/datasources/local/hive_adapter.dart

---

## Phase 2: Foundational (Pré-requisitos Bloqueantes)

**Objetivo**: Infraestrutura de domínio e dados que DEVE estar pronta antes de qualquer story ser implementada

**⚠️ CRÍTICO**: Nenhuma tarefa de user story pode começar até esta fase estar completa

- [ ] T006 Criar repositório de perguntas interface em lib/domain/repositories/pergunta_repository.dart
- [ ] T007 [P] Implementar datasource local de perguntas em lib/data/datasources/local/pergunta_local_datasource.dart
- [ ] T008 [P] Implementar repositório local de perguntas em lib/data/repositories/pergunta_repository_impl.dart
- [ ] T009 Criar classe PerfilDistribuicaoDificuldade em lib/domain/entities/perfil_dificuldade.dart
- [ ] T010 [P] Criar classe HistoricoRecenteDePerguntas em lib/domain/entities/historico_pergunta.dart
- [ ] T011 [P] Implementar datasource local de histórico em lib/data/datasources/local/historico_pergunta_local_datasource.dart
- [ ] T012 Criar classe ConfiguracaoPartida com maxErrosConsecutivos=5 em lib/domain/entities/configuracao_partida.dart
- [ ] T013 Criar constantes atualizadas em lib/utils/constants.dart (maxErros: 5, janelaAntiRep: 2h)
- [ ] T014 [P] Criar validador de catálogo em lib/domain/usecases/validar_catalogo.dart (1000 itens, 10+ categorias)
- [ ] T015 Implementar carregamento de catálogo embarcado em lib/data/datasources/local/pergunta_local_datasource.dart

**Checkpoint**: Infraestrutura pronta - implementação de user stories pode começar em paralelo

---

## Phase 3: User Story 1 - Base Inicial com 1000 Perguntas (Priority: P1) 🎯 MVP

**Objetivo**: Disponibilizar 1000 perguntas únicas, válidas e bem distribuídas

**Teste Independente**: Ao iniciar o app, validar que o arquivo de catálogo embarcado contém exatamente 1000 perguntas, no mínimo 10 categorias com 50+ perguntas cada, e nenhuma duplicidade.

### Implementação para User Story 1

- [ ] T016 [P] [US1] Gerar arquivo JSON de 1000 perguntas em assets/data/perguntas_embarcadas.json
- [ ] T017 [P] [US1] Validar distribuição de perguntas por categoria (10 min, 50 cada) no JSON gerado
- [ ] T018 [P] [US1] Validar dificuldade de cada pergunta (1-10) no JSON gerado
- [ ] T019 [US1] Implementar carregamento automático de catálogo embarcado em lib/data/datasources/local/pergunta_local_datasource.dart
- [ ] T020 [US1] Adicionar teste unitário de validação de catálogo em test/unit/domain/usecases/validar_catalogo_test.dart
- [ ] T021 [P] [US1] Adicionar teste de integração: abrir app, validar 1000 perguntas carregadas em test/integration/catalog_loading_test.dart
- [ ] T022 [US1] Registrar timestamp de carregamento do catálogo embarcado em Progresso

**Checkpoint**: User Story 1 implementada e testável independentemente

---

## Phase 4: User Story 2 - Sorteio Adaptativo por Nível (Priority: P1)

**Objetivo**: Selecionar perguntas seguindo distribuição ponderada progressiva por nível

**Teste Independente**: Simular 100+ sorteios por nível (1-10) e validar que 70% das perguntas sorteadas estão nas faixas esperadas para cada nível.

### Implementação para User Story 2

- [ ] T023 [P] [US2] Definir matriz de pesos por nível em lib/domain/entities/perfil_dificuldade.dart (níveis 1-10)
- [ ] T024 [P] [US2] Implementar algoritmo de sorteio aleatório ponderado em lib/domain/usecases/selecionar_pergunta.dart
- [ ] T025 [US2] Integrar seleção com PlayGame use case existente em lib/domain/usecases/play_game.dart
- [ ] T026 [P] [US2] Adicionar teste unitário de distribuição ponderada em test/unit/domain/usecases/selecionar_pergunta_test.dart
- [ ] T027 [US2] Validar respeito a dificuldade alvo em sorteio: 70% em faixa esperada para nível 1 em test/unit/domain/usecases/selecionar_pergunta_test.dart
- [ ] T028 [US2] Validar respeito a dificuldade alvo em sorteio: 70% em faixa esperada para nível 10 em test/unit/domain/usecases/selecionar_pergunta_test.dart
- [ ] T029 [P] [US2] Adicionar teste de integração de sorteio progressivo em test/integration/adaptive_selection_test.dart

**Checkpoint**: User Stories 1 E 2 implementadas e funcionando independentemente

---

## Phase 5: User Story 3 - Anti-Repetição e Novo Limite de Erros (Priority: P2)

**Objetivo**: Bloquear repetição de perguntas por 2 horas (wall-clock) e alterar game over para 5 erros

**Teste Independente**: Em sessão contínua de 2 horas, validar que pergunta respondida não reaparece; validar game over no 5º erro apenas.

### Implementação para User Story 3

- [ ] T030 [P] [US3] Implementar datasource de histórico temporal em lib/data/datasources/local/historico_pergunta_local_datasource.dart
- [ ] T031 [P] [US3] Criar use case de verificação de elegibilidade em lib/domain/usecases/verificar_elegibilidade_pergunta.dart
- [ ] T032 [US3] Integrar anti-repetição com PlayGame e seleção em lib/domain/usecases/selecionar_pergunta.dart
- [ ] T033 [P] [US3] Implementar fallback de reset de histórico quando pool elegível esgotar em lib/domain/usecases/selecionar_pergunta.dart
- [ ] T034 [US3] Atualizar GameConstants.maxErrosConsecutivos de 3 para 5 em lib/utils/constants.dart
- [ ] T035 [US3] Garantir compatibilidade com GameBloc existente (estado de game over no 5º erro) em lib/presentation/bloc/game_bloc.dart
- [ ] T036 [P] [US3] Adicionar teste unitário de anti-repetição 2h em test/unit/domain/usecases/verificar_elegibilidade_pergunta_test.dart
- [ ] T037 [P] [US3] Adicionar teste unitário de fallback de reset em test/unit/domain/usecases/verificar_elegibilidade_pergunta_test.dart
- [ ] T038 [P] [US3] Adicionar teste unitário de game over no 5º erro em test/unit/domain/usecases/check_answer_test.dart (ajuste existente)
- [ ] T039 [US3] Adicionar teste de integração de anti-repetição e reset em test/integration/non_repetition_test.dart
- [ ] T040 [US3] Adicionar teste de integração de game over em test/integration/game_over_threshold_test.dart

**Checkpoint**: Todas as 3 user stories implementadas e independentemente funcionais

---

## Phase 6: Polish & Testes Cruzados

**Objetivo**: Validação final, cobertura de testes, documentação e cleanup

- [ ] T041 [P] Adicionar testes unitários de compatibilidade de perguntas com easy_localization em test/unit/data/models/pergunta_model_test.dart
- [ ] T042 [P] Validar persistência de histórico após restart do app em test/integration/offline_resume_test.dart (estender existente)
- [ ] T043 Executar flutter analyze e resolver todos os warnings em lib/
- [ ] T044 [P] Executar flutter test test/unit/ test/integration/ e validar 100% de passing
- [ ] T045 [P] Validar cobertura de testes de regras críticas (>90% game rules, anti-rep, seleção)
- [ ] T046 Atualizar README.md com informações sobre catálogo de perguntas e regras de seleção
- [ ] T047 [P] Gerar arquivo perguntas.json final para sincronização com GitHub (1000 itens, validado)
- [ ] T048 Adicionar comentários de implementação em lib/domain/usecases/ para lógica de seleção e anti-repetição
- [ ] T049 Validar que todos os testes de feature 001 (QuizVerse: Forca) continuam passando
- [ ] T050 [P] Executar flutter run em emulador e testar fluxo completo (3 níveis, verificar anti-rep, game over no 5º erro)

**Checkpoint**: Feature 002 pronta para merge

---

## Dependências & Ordem de Execução

### Dependências por Fase

- **Setup (Phase 1)**: Sem dependências - pode começar imediatamente
- **Foundational (Phase 2)**: Depende de Setup completo - **BLOQUEIA** todas as user stories
- **User Stories (Phase 3+)**: Todas dependem de Foundational completo
  - Podem rodar em paralelo se houver capacidade de time
  - Ou sequencialmente em ordem de prioridade (P1 → P2 → P3)
- **Polish (Phase 6)**: Depende de todas as stories desejadas estarem completas

### Dependências Internas de User Stories

- **US1 (Base 1000 Perguntas)**: Começa após Foundational - Independente de US2 e US3
- **US2 (Sorteio Adaptativo)**: Começa após Foundational - Recomendado após US1 para melhor teste
- **US3 (Anti-Repetição + 5 Erros)**: Começa após Foundational - Recomendado após US2 para cascata coerente

### Oportunidades de Paralelização

- Todas as tarefas [P] em Setup podem rodar em paralelo
- Todas as tarefas [P] em Foundational podem rodar em paralelo
- Após Foundational completo: US1, US2, US3 podem iniciar em paralelo com time distribuído
- Testes [P] de cada US podem rodar em paralelo

---

## Exemplo de Execução (MVP)

Para entrega mais rápida (MVP com US1 apenas):

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: US1
4. Complete Phase 6: Polish & Testes Cruzados (apenas validação existente)
5. Merge para main

Prazo estimado: 3-5 dias com 1 dev full-time

Para full feature (US1 + US2 + US3):

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Parallelizar: Phase 3 (US1), Phase 4 (US2), Phase 5 (US3)
4. Complete Phase 6: Polish & Testes Cruzados
5. Merge para main

Prazo estimado: 5-7 dias com 1 dev full-time (sequencial) ou 3-4 dias com 3 devs (paralelo)

---

## Total de Tarefas

- **Phase 1**: 5 tarefas
- **Phase 2**: 10 tarefas
- **Phase 3 (US1)**: 7 tarefas
- **Phase 4 (US2)**: 7 tarefas
- **Phase 5 (US3)**: 11 tarefas
- **Phase 6**: 10 tarefas

**Total**: 50 tarefas (T001–T050)

---

## Validação & Critérios de Sucesso

Antes de marcar tasks como completas:

✅ Código sem warnings (flutter analyze clean)  
✅ Testes relacionados passam (flutter test)  
✅ Cobertura de regras críticas > 90%  
✅ Offline-first preservado (sem backend adicional)  
✅ Compatibilidade com feature 001 mantida  
✅ Documentação em PT-BR atualizada  
✅ Branch atualizada com main antes de merge  
