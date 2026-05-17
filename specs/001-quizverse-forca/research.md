# Research Summary: QuizVerse: Forca

**Phase**: Phase 0 (Research)
**Date**: 2026-05-17
**Status**: Complete

## Decisões

### 1. Modelo de usuário local/anônimo

- Decision: Não haverá conta, login ou backend de usuário em P1.
- Rationale: Preserva offline-first, reduz complexidade e remove dependências de autenticação.
- Alternatives considered: Conta opcional por e-mail; login social; backend próprio.

### 2. Estado inicial de jogo

- Decision: Estado inicial fixo em nível 1, pontuação 0 e 1 troféu.
- Rationale: Garante onboarding justo e permite primeira continuidade pós-Game Over.
- Alternatives considered: Começar sem troféus; troféus aleatórios; estado inicial configurável.

### 3. Regra de progressão e Game Over

- Decision: Level-up a cada 10 acertos; Game Over no 5º erro consecutivo.
- Rationale: Alinhamento com a constituição v2.0.0 (Princípio V).
- Alternatives considered: Game Over com 3 erros; dificuldade dinâmica sem limiar fixo.

### 4. Estrutura de contexto educativo multilíngue

- Decision: `contexto_historico` como objeto por idioma (`pt_BR`, `en`, `it`) com fallback obrigatório para `pt_BR`.
- Rationale: Simplifica validação e renderização sem quebra de experiência.
- Alternatives considered: Contexto em string única; tradução sob demanda via serviço externo.

### 5. Política de sincronização de conteúdo

- Decision: Sincronização silenciosa em background a cada 24h ou ao subir nível, com merge idempotente.
- Rationale: Conteúdo atualizado sem interromper gameplay e sem corromper cache local.
- Alternatives considered: Sync apenas ao abrir app; sync manual pelo usuário.

### 6. Tratamento de payload inválido

- Decision: Se 100% do payload estiver inválido, manter cache local e registrar erro sem modal bloqueante.
- Rationale: Resiliência operacional e continuidade de jogo offline-first.
- Alternatives considered: Bloquear jogo até nova sync válida; limpar cache local.

### 7. Segurança e privacidade para P1

- Decision: HTTPS obrigatório, sem telemetria/crash reporting/criptografia local em P1.
- Rationale: Escopo enxuto para MVP, mantendo superfície de risco controlada.
- Alternatives considered: Criptografia local imediata; crash analytics desde P1.

## Resultado

- Nenhum item NEEDS CLARIFICATION remanescente.
- Direção técnica e critérios de validação definidos para Phase 1.
- Conformidade com constituição v2.0.0 confirmada.
