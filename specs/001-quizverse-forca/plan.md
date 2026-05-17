# Implementation Plan: QuizVerse: Forca

> Documento em Português (Brasil), com decisões objetivas e sem jargões
> desnecessários.

**Branch**: `001-quizverse-forca` | **Data**: 2026-05-16 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification de `/specs/001-quizverse-forca/spec.md`,
clarificada em 2026-05-16 com 9 questões de esclarecimento resolvidas.

---

## Resumo

QuizVerse: Forca é um jogo mobile de adivinhação de palavras (Forca Moderna)
construído em Flutter 3.x + Dart 3.x, com foco em experiência offline-first.
O jogador avança de nível ao acertar 10 respostas consecutivas, acumula troféus,
e pode gastar troféus para continuar após 3 erros consecutivos. As perguntas são
sincronizadas silenciosamente em background a partir de um endpoint GitHub (a
cada 24 horas ou no level-up), com fallback para um pacote local embarcado no
app. O jogo suporta PT-BR, Inglês e Italiano via easy_localization, com fallback
obrigatório para PT-BR.

---

## Contexto Técnico

**Language/Version**: Flutter 3.x + Dart 3.x

**Primary Dependencies**:
- `hive 2.x` + `hive_flutter 1.x` — armazenamento offline-first
- `bloc 8.x` + `flutter_bloc 8.x` **ou** `riverpod 2.x` + `flutter_riverpod 2.x` — gerenciamento de estado (decisão na fase de setup)
- `easy_localization 3.x` — suporte PT-BR/EN/IT com fallback
- `http 1.x` — chamadas ao endpoint GitHub raw

**Dev Dependencies**:
- `flutter_test` (SDK) — testes de widget e integração
- `mockito 5.x` — mocking de repositórios e datasources
- `bloc_test 9.x` — testes de BLoC (se BLoC escolhido)
- `build_runner` + `hive_generator 2.x` — geração de adaptadores Hive

**Storage**: Hive 2.x (principal); SQLite como alternativa documentada em
`data-model.md`. Progresso, troféus, perguntas e estado de partida são todos
locais — sem sincronização de dados do jogador para nuvem.

**Testing**: `flutter_test` + `mockito 5.x` + `bloc_test 9.x`. Cobertura mínima
obrigatória de 90% nas regras de jogo (Princípio III).

**Target Platform**: iOS 12.0+ e Android 5.0+ (API 21+), mobile-only.

**Documentação**: Português (Brasil) obrigatório. Código e comentários em inglês
são aceitos; toda documentação de especificação, plano e tarefas em PT-BR.

**Localização**: Português (Brasil), Inglês, Italiano. Fallback obrigatório para
PT-BR quando chave ausente. Arquivos em `assets/locales/`. Campo
`contexto_historico` das perguntas é um `Map<String, String>` com chaves
`pt_BR`, `en`, `it`.

**Sincronização de Conteúdo**: GitHub raw endpoint
`https://raw.githubusercontent.com/colliplanura/quizz/main/perguntas.json`.
Frequência: 24 horas ou ao avançar de nível (o que ocorrer primeiro). HTTPS
obrigatório. Payload inválido: manter cache local, registrar erro no log,
continuar jogo sem alerta modal.

**Project Type**: Mobile App (Flutter — iOS + Android)

**Performance Goals**:
- Carregamento da primeira pergunta a partir do cache local: < 2 segundos
- Tamanho do pacote de perguntas embarcado: < 10 MB
- Resposta de UI (toque em letra → feedback visual): < 16 ms (60 fps)

**Constraints**:
- Totalmente offline-first: jogo funciona sem rede, usando cache local
- Sem autenticação, sem contas, sem backend dedicado
- Progresso armazenado apenas no dispositivo (local-only)
- HTTPS obrigatório para sincronização com GitHub
- Sem telemetria, sem crash reporting, sem política de privacidade em P1
- Contexto educativo: 1–2 frases, máximo 120 caracteres por idioma

**Scale/Scope**:
- Níveis: ilimitados (progressão indefinida)
- Pool de perguntas: 500–1.000 questões
- Estado inicial do jogador: Nível 1, Pontuação 0, 1 Troféu
- Regras fixas: 10 acertos por nível, 3 erros consecutivos = Game Over

---

## Constitution Check

*GATE: Deve passar antes da Phase 0. Reavaliado após Phase 1 (design).*

### I. Arquitetura Flutter Mobile em Primeiro Lugar

✅ **APROVADO** — O projeto é exclusivamente mobile Flutter. A lógica de negócio
está separada em três camadas: `lib/domain` (casos de uso e entidades),
`lib/data` (repositórios e datasources) e `lib/presentation` (BLoC + telas +
widgets). A UI não contém regras de jogo.

### II. Jogo Offline-First e Sincronização Silenciosa

✅ **APROVADO** — Hive 2.x persiste progresso, troféus, perguntas e estado da
partida localmente. Um pacote mínimo de perguntas é embarcado no app para o
primeiro uso sem rede. A sincronização com GitHub é assíncrona, silenciosa e
idempotente. Falhas de rede não corrompem o estado local. Progresso do jogador
nunca é perdido.

### III. Estado e Regras Testáveis (NÃO NEGOCIÁVEL)

✅ **APROVADO** — Gerenciamento de estado via BLoC 8.x ou Riverpod 2.x, ambos
isolam efeitos colaterais da UI. Cobertura mínima de 90% nas regras críticas
(level-up, Game Over, continue/restart, validação de resposta) é mandatória.
Tasks T031–T035 cobrem testes antes da implementação.

### IV. Comunicação Clara, Acessibilidade e Idioma do Projeto

✅ **APROVADO** — Toda documentação (spec, plan, tasks, quickstart, data-model,
contracts) está em Português (Brasil). O app suporta PT-BR, EN e IT via
easy_localization com fallback PT-BR. Widgets de UI usam rótulos acessíveis e
contraste adequado.

### V. Conteúdo Confiável e Progressão Justa

✅ **APROVADO** — `resposta` é normalizada (lowercase, sem acentos);
`exibicao_resposta` preserva acentos para exibição. Progressão objetiva: 10
acertos/nível, 3 erros consecutivos = Game Over. Continue consome 1 troféu;
bloqueado se troféus = 0. Contexto educativo: 1–2 frases, máx 120 chars/idioma,
validado em sincronização.

**Resultado**: ✅ Todos os 5 princípios aprovados. Sem violações. Prosseguir.

---

## Estrutura do Projeto

### Documentação (este recurso)

```text
specs/001-quizverse-forca/
├── plan.md              # Este arquivo (saída do /speckit.plan)
├── research.md          # Saída da Phase 0 (/speckit.plan)
├── data-model.md        # Saída da Phase 1 (/speckit.plan)
├── quickstart.md        # Saída da Phase 1 (/speckit.plan)
├── contracts/           # Saída da Phase 1 (/speckit.plan)
│   └── api-github.md    # Contrato do endpoint GitHub raw
└── tasks.md             # Saída da Phase 2 (/speckit.tasks)
```

### Código-Fonte (raiz do repositório)

```text
lib/
├── main.dart                               # Bootstrap: easy_localization + Hive + tema
├── config/
│   └── routes.dart                         # Roteamento de telas
├── domain/
│   ├── entities/
│   │   ├── pergunta.dart                   # Entidade Pergunta
│   │   ├── progresso.dart                  # Entidade Progresso (nível, pontuação, troféus)
│   │   ├── partida.dart                    # Entidade Partida (pergunta ativa, erros, acertos)
│   │   ├── trofeu.dart                     # Entidade Trofeu
│   │   └── configuracao_idioma.dart        # Entidade ConfiguracaoIdioma
│   ├── repositories/
│   │   ├── pergunta_repository.dart        # Contrato: buscar perguntas por dificuldade
│   │   ├── progresso_repository.dart       # Contrato: carregar/salvar progresso
│   │   └── sync_repository.dart            # Contrato: sincronizar com GitHub
│   └── usecases/
│       ├── play_game.dart                  # Caso de uso: iniciar/restaurar partida offline
│       ├── check_answer.dart               # Caso de uso: validar letra/resposta
│       ├── advance_level.dart              # Caso de uso: level-up, reset de streak
│       ├── game_over.dart                  # Caso de uso: Game Over com opções
│       └── continue_game.dart              # Caso de uso: continuar (gasta 1 troféu)
├── data/
│   ├── models/
│   │   ├── pergunta_model.dart             # Model + mapeamento domain<->data + Hive
│   │   ├── progresso_model.dart
│   │   ├── partida_model.dart
│   │   ├── trofeu_model.dart
│   │   └── configuracao_idioma_model.dart
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── hive_adapter.dart           # Registro de adaptadores e abertura de boxes
│   │   │   ├── pergunta_local_source.dart  # Carrega perguntas do Hive + embarcado
│   │   │   ├── progresso_local_source.dart
│   │   │   └── trofeu_local_source.dart
│   │   └── remote/
│   │       └── github_sync_source.dart     # HTTP GET → perguntas.json
│   └── repositories/
│       ├── pergunta_repository_impl.dart
│       ├── progresso_repository_impl.dart
│       └── sync_repository_impl.dart
├── presentation/
│   ├── bloc/
│   │   ├── game_bloc.dart                  # Lógica central do jogo
│   │   ├── game_event.dart                 # Eventos: start, guess, continue, restart
│   │   └── game_state.dart                 # Estados: loading, running, levelUp, gameOver
│   ├── pages/
│   │   ├── game_page.dart                  # Tela principal do jogo
│   │   └── game_over_page.dart             # Tela de Game Over
│   └── widgets/
│       ├── palavras_display.dart           # Palavra mascarada + letras reveladas
│       ├── error_bar.dart                  # Barra de erros animada 0–3
│       ├── letra_button.dart               # Grade de letras habilitadas/desabilitadas
│       ├── trophy_display.dart             # Exibição de troféus, nível, pontuação
│       └── level_up_celebration.dart       # Animação de celebração de level-up
├── services/
│   ├── logging_service.dart                # Logs locais de sync e validação
│   ├── sync_service.dart                   # Orquestração da sincronização background
│   └── game_state_persistence_service.dart # Persistência em cada transição
└── utils/
    ├── constants.dart                      # Regras fixas: 10 acertos, 3 erros, estado inicial
    └── validators.dart                     # Normalização + fallback contexto_historico

assets/
├── locales/
│   ├── pt_BR.json                          # Traduções PT-BR (idioma principal)
│   ├── en.json                             # Traduções EN
│   └── it.json                             # Traduções IT
└── data/
    └── perguntas_embarcadas.json           # Pacote mínimo para primeiro uso offline

test/
├── unit/
│   └── domain/
│       └── usecases/
│           ├── advance_level_test.dart     # Regras de level-up
│           ├── game_over_test.dart         # Regras de Game Over (3 erros)
│           └── continue_game_test.dart     # Continue/restart + bloqueio 0 troféus
├── widget/
│   └── game_page_test.dart                 # Fluxo de tela offline completo
└── integration/
    └── offline_resume_test.dart            # Restauração de partida após relaunch
```

**Decisão de Estrutura**: Clean Architecture em três camadas (`domain`, `data`,
`presentation`) conforme Princípio I da constituição. BLoC 8.x ou Riverpod 2.x
(decisão durante T001/T002, Phase 1 de setup). Hive 2.x para storage local
offline-first. Sem backend dedicado — sincronização direta via GitHub raw
endpoint.

---

## Fases

### Phase 0: Pesquisa (Concluída)

**Status**: ✅ Completa
**Artefato**: [research.md](research.md)

Nenhuma pesquisa adicional foi necessária. As 9 clarificações resolvidas em
`/speckit.clarify` (2026-05-16) eliminaram todas as ambiguidades críticas:

- Modelo local/anônimo: sem contas, sem backend
- Estado inicial: Nível 1, Pontuação 0, 1 Troféu
- Níveis ilimitados, pool de 500–1.000 perguntas
- Contexto educativo: 1–2 frases, máx 120 chars/idioma
- Segurança P1: HTTPS only, sem criptografia local
- `contexto_historico` como `Map<String, String>` `{pt_BR, en, it}` com fallback PT-BR
- Payload 100% inválido: manter cache, logar, continuar sem modal
- Game Over com 0 troféus: desabilitar "Continuar", exibir mensagem explicativa
- Primeiro uso offline: pacote de perguntas embarcado no app

### Phase 1: Design (Concluída)

**Status**: ✅ Completa
**Artefatos**:
- [data-model.md](data-model.md) — 5 entidades: `Pergunta`, `Progresso`, `Partida`, `Trofeu`, `ConfiguracaoIdioma`
- [contracts/api-github.md](contracts/api-github.md) — contrato do endpoint GitHub raw (HTTPS, schema multilíngue)
- [quickstart.md](quickstart.md) — setup do ambiente de desenvolvimento Flutter
- Contexto do agente atualizado em `.github/copilot-instructions.md`

### Phase 2: Tarefas (Pronta para Execução)

**Status**: ✅ Tasks geradas
**Artefato**: [tasks.md](tasks.md) — T001–T086, organizadas em 6 fases

Referência por fase:

| Fase | Objetivo | Tasks |
|------|----------|-------|
| Phase 1 Setup | Inicializar projeto Flutter e infraestrutura base | T001–T008 |
| Phase 2 Foundational | Entidades, repositórios, datasources, Hive | T009–T030 |
| Phase 3 US1 (MVP) | Gameplay offline completo (P1) | T031–T050, T086 |
| Phase 4 US2 | Sincronização silenciosa GitHub (P2) | T051–T065 |
| Phase 5 US3 | Troféus, idioma e contexto educativo (P2) | T066–T080 |
| Phase 6 Polish | Acessibilidade, performance, release | T081–T085 |

**Cobertura de testes mandatória**: ≥ 90% das regras de jogo (Princípio III).
Tasks T031–T035 criam os testes antes da implementação (T036–T050).

---

## Rastreamento de Complexidade

> Nenhuma violação identificada no Constitution Check.

Sem entradas necessárias.
