# Implementation Plan: Expansao da Base de Perguntas

> Documento em Portugues (Brasil), com decisoes objetivas e sem jargoes desnecessarios.

**Branch**: `002-expand-question-bank-clean` | **Date**: 2026-05-17 | **Spec**: `/specs/002-expand-question-bank/spec.md`

**Input**: Feature specification from `/specs/002-expand-question-bank/spec.md`

## Summary

Expandir o catalogo inicial do QuizVerse: Forca para 1000 perguntas validas e variadas, com distribuicao de dificuldade progressiva por nivel, anti-repeticao por 2 horas em wall-clock e ajuste de game over para 5 erros consecutivos. A implementacao deve preservar o jogo offline-first, manter compatibilidade com as regras atuais de pontuacao/progressao e garantir testes deterministas das regras centrais.

## Technical Context

**Language/Version**: Flutter 3.x + Dart 3.x

**Primary Dependencies**: hive 2.x, hive_flutter 1.x, flutter_bloc 8.x (ou Riverpod 2.x), easy_localization 3.x, http 1.x

**Storage**: Hive local para catalogo, historico recente de perguntas e estado de partida

**Testing**: flutter_test, bloc_test, mockito, testes unitarios e de integracao

**Target Platform**: Android e iOS

**Documentacao**: Portugues (Brasil) obrigatorio

**Localizacao**: PT-BR, EN e IT (PT-BR como fallback)

**Sincronizacao de Conteudo**: origem em JSON remoto no GitHub raw; execucao em background (24h ou level-up), sem bloquear gameplay

**Project Type**: Aplicativo mobile offline-first

**Performance Goals**:
- Sorteio + carregamento da proxima pergunta em ate 200ms no p95, com 30 execucoes por cenario (nivel baixo/medio/alto)
- Validação de predominancia por nivel em 300 sorteios deterministas para cenarios SC-002 e SC-003

**Constraints**:
- Anti-repeticao obrigatoria por 2h em wall-clock
- Em pool elegivel vazio: reset de historico e novo sorteio imediato
- Sem regressao nas regras existentes de progressao e pontuacao
- Sem backend adicional para gameplay principal

**Scale/Scope**:
- Catalogo inicial de 1000 perguntas
- Minimo de 10 categorias com ao menos 50 perguntas por categoria
- Curva de dificuldade em 10 niveis

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Gate Pre-Research

- Principio I (Arquitetura Flutter Mobile em Primeiro Lugar): **PASS**
  Mudancas concentradas em Data/Domain/Presentation, sem mover regra de negocio para UI.
- Principio II (Offline-First e Sync Silenciosa): **PASS**
  Selecao e anti-repeticao funcionam localmente; sincronizacao continua assicrona e nao bloqueante.
- Principio III (Estado e Regras Testaveis): **PASS**
  Regras criticas (distribuicao, elegibilidade, fallback e game over) estao mapeadas para testes automatizados.
- Principio IV (Comunicacao Clara, Acessibilidade e Idioma): **PASS**
  Artefatos da feature em PT-BR; impacto de localizacao preservado (PT-BR/EN/IT).
- Principio V (Conteudo Confiavel e Progressao Justa): **PASS**
  Regra de 5 erros consecutivos e progressao por dificuldade estao explicitadas e verificaveis.

Resultado do gate pre-research: **APROVADO**.

### Gate Post-Design

- Pesquisa consolidou decisoes sem pendencias de clarificacao: **PASS**
- Modelo de dados cobre catalogo, distribuicao, historico e configuracao de partida: **PASS**
- Contrato funcional descreve elegibilidade, prioridade de regras e fallback de pool vazio: **PASS**
- Quickstart cobre execucao, validacao e testes minimos da feature: **PASS**

Resultado do gate post-design: **APROVADO**.

## Phase 0: Research Output

Arquivo gerado: `/specs/002-expand-question-bank/research.md`

Decisoes consolidadas:
- distribuicao ponderada progressiva por nivel
- anti-repeticao por 2h wall-clock
- reset de historico ao esgotar pool elegivel
- prioridade para anti-repeticao + aleatoriedade em conflito de faixa alvo
- variedade minima com 10 categorias e 50+ perguntas por categoria
- limite de game over alterado para 5 erros consecutivos

## Phase 1: Design Output

Arquivos gerados/atualizados:
- `/specs/002-expand-question-bank/data-model.md`
- `/specs/002-expand-question-bank/contracts/question-catalog.md`
- `/specs/002-expand-question-bank/quickstart.md`

Escopo de design:
- definicao de entidades e validacoes do catalogo
- regras de distribuicao por nivel e criterios de elegibilidade
- transicoes de estado para anti-repeticao/fallback/game over
- contrato funcional para validacao de dados e comportamento de selecao

## Project Structure

### Documentation (this feature)

```text
specs/002-expand-question-bank/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── question-catalog.md
└── tasks.md
```

### Source Code (repository root)

```text
assets/
└── data/
    └── perguntas_inicial.json

lib/
├── data/
│   ├── datasources/
│   │   └── local/
│   │       └── historico_pergunta_local_datasource.dart
│   ├── models/
│   │   └── pergunta_model.dart
│   └── repositories/
│       └── pergunta_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── pergunta_repository.dart
│   └── usecases/
│       ├── selecionar_pergunta.dart
│       ├── play_game.dart
│       ├── advance_level.dart
│       ├── check_answer.dart
│       ├── game_over.dart
│       └── continue_game.dart
├── presentation/
│   └── bloc/
│       └── game_bloc.dart
└── utils/
    └── constants.dart

test/
├── integration/
│   ├── adaptive_selection_performance_test.dart
│   └── offline_resume_test.dart
└── unit/
    └── domain/
        └── usecases/
            ├── selecionar_pergunta_test.dart
            ├── game_over_test.dart
            ├── continue_game_test.dart
            └── advance_level_test.dart
```

**Structure Decision**: manter aplicacao Flutter unica com Clean Architecture, priorizando regras de jogo no dominio e persistencia local no data layer, com testes deterministas para as regras de selecao, anti-repeticao e game over.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
| ----------- | ------------ | ------------------------------------- |
| None | N/A | N/A |
