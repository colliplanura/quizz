# Implementation Plan: Expansão da Base de Perguntas

**Branch**: `002-create-new-spec` | **Date**: 2026-05-16 | **Spec**: `/specs/002-expand-question-bank/spec.md`

**Input**: Feature specification from `/specs/002-expand-question-bank/spec.md`

## Summary

Expandir o banco inicial para 1000 perguntas classificadas em 10 níveis,
aplicar seleção aleatória adaptativa por nível com anti-repetição de 2 horas
em tempo corrido, e alterar o limiar de game over de 3 para 5 erros
consecutivos, preservando offline-first e testabilidade das regras.

## Technical Context

**Language/Version**: Dart 3.x com Flutter 3.x

**Primary Dependencies**: flutter_bloc 8.x, hive 2.x/hive_flutter, easy_localization, http

**Storage**: Hive local para progresso, perguntas e histórico recente de perguntas respondidas

**Testing**: flutter_test, bloc_test, testes unitários e de integração

**Target Platform**: Android e iOS

**Documentação**: Português (Brasil), sem exceções para esta feature

**Localização**: PT-BR, EN, IT (sem mudança estrutural nesta feature)

**Sincronização de Conteúdo**: GitHub raw JSON, verificação a cada 24h ou level-up; fallback para cache local

**Project Type**: Aplicativo mobile offline-first

**Performance Goals**: sorteio de nova pergunta sem atraso perceptível (<200ms em dispositivo alvo)

**Constraints**: sem backend dedicado, funcionamento offline obrigatório, consistência após restart

**Scale/Scope**: 1000 perguntas iniciais; mínimo 10 categorias com 50 perguntas cada

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Research Gate

- Princípio I (Arquitetura Flutter): PASS
- Princípio II (Offline-first): PASS
- Princípio III (Regras testáveis): PASS (feature orientada a regra de domínio)
- Princípio IV (Clareza/documentação): PASS
- Princípio V (Progressão justa): PASS

Resultado do Gate: PASS

### Post-Design Gate

- Design mantém separação de camadas e armazenamento local: PASS
- Contrato de seleção preserva aleatoriedade e anti-repetição: PASS
- Modelo de dados cobre persistência de histórico temporal: PASS
- Regra de game over com 5 erros está alinhada à constituição vigente: PASS

Resultado do Gate pós-design: PASS

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
lib/
├── config/
├── data/
├── domain/
├── presentation/
├── services/
├── utils/
└── main.dart

test/
├── unit/
├── integration/
├── widget/
└── widget_test.dart
```

**Structure Decision**: Manter estrutura mobile única existente com Clean Architecture. A feature será implementada majoritariamente em domain (regras de seleção/anti-repetição), data (persistência de histórico e catálogo), e testes unitários/integration.

## Phase 0: Research Output

Arquivo gerado: `/specs/002-expand-question-bank/research.md`

Principais decisões:

- distribuição ponderada progressiva por nível
- anti-repetição por 2h em wall-clock
- reset de histórico quando pool elegível esgotar
- prioridade anti-repetição + aleatoriedade em conflitos de filtro
- regra objetiva de variedade (10 categorias, 50 por categoria)

## Phase 1: Design Output

Arquivos gerados:

- `/specs/002-expand-question-bank/data-model.md`
- `/specs/002-expand-question-bank/contracts/question-catalog.md`
- `/specs/002-expand-question-bank/quickstart.md`

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
| ----------- | ------------ | ------------------------------------- |
| None | N/A | N/A |
