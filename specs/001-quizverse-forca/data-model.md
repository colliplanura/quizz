# Data Model: QuizVerse: Forca

**Phase**: Phase 1 (Design)  
**Date**: 2026-05-16  
**Status**: Final

---

## Overview

O modelo de dados do QuizVerse: Forca é composto por 5 entidades principais,
otimizadas para offline-first com Hive ou SQLite. Nenhuma sincronização de
entidades para nuvem (progresso é local-only, perguntas são read-only).

---

## Entity Definitions

### 1. Pergunta (Question)

**Purpose**: Representa uma pergunta/palavra-alvo do jogo.

**Fields**:

| Field | Type | Constraints | Example |
|-------|------|-------------|---------|
| `id` | String (UUID) | PK, required, unique | "550e8400-e29b-41d4-a716-446655440000" |
| `pergunta` | String | required, 2–50 chars | "Qual é a capital da Itália?" |
| `resposta` | String | required, normalized (lowercase, sem acentos) | "roma" |
| `exibicao_resposta` | String | required, with accents for display | "Roma" |
| `categoria` | String | required, enum: ["história", "geografia", "ciência", "cultura", "outro"] | "geografia" |
| `dificuldade` | Integer | required, range [1–10] | 5 |
| `contexto_historico` | String | required, 1-2 frases, max 120 chars (per clarificação Q4) | "Roma foi fundada em 753 aC no Lácio." |
| `data_criacao` | DateTime | optional, RFC 3339 | "2026-05-10T14:30:00Z" |

**Normalization Rules**:

- `resposta`: Converter para lowercase, remover acentos/diacríticos (á → a, é → e, etc.)
- `exibicao_resposta`: Preservar formatação original com acentos
- `contexto_historico`: Validar length <= 120 chars; truncar com "..." em UI se necessário, logar warning

**Indexes**:

- Primary: `id`
- Secondary: `categoria` (query by category)
- Secondary: `dificuldade` (query by difficulty)

**Example Document**:

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "pergunta": "Qual é a capital da Itália?",
  "resposta": "roma",
  "exibicao_resposta": "Roma",
  "categoria": "geografia",
  "dificuldade": 5,
  "contexto_historico": "Roma foi fundada em 753 aC no Lácio.",
  "data_criacao": "2026-05-10T14:30:00Z"
}
```

---

### 2. Progresso (Player Progress)

**Purpose**: Armazena o progresso global do jogador (nível, pontuação total,
troféus).

**Fields**:

| Field | Type | Constraints | Example |
|-------|------|-------------|---------|
| `id` | String | PK, fixed: "player_progress" | "player_progress" |
| `nivel_atual` | Integer | required, >= 1 | 5 |
| `pontuacao_total` | Integer | required, >= 0 | 1250 |
| `trofeus_ganhos` | Integer | required, >= 0, can decrease (gasto em continue) | 3 |
| `acertos_consecutivos` | Integer | required, [0–10] | 7 |
| `erros_consecutivos` | Integer | required, [0–3] | 1 |
| `timestamp_ultima_sincronizacao` | DateTime | required, RFC 3339 | "2026-05-16T10:00:00Z" |
| `partida_ativa` | Object | optional (null se no partida, or Partida object) | {...} |
| `data_atualizacao` | DateTime | required, RFC 3339 | "2026-05-16T14:30:00Z" |

**State Transitions**:

- Nível aumenta quando `acertos_consecutivos == 10`
- Game Over quando `erros_consecutivos == 3`
- Continue gasta 1 troféu, mantém nível/pontuação
- Restart retorna ao nível 1, pontuação 0, sem gasto de troféu

**Constraints**:

- Estado inicial: nivel=1, pontuacao=0, trofeus=1 (per clarificação Q2)
- `trofeus_ganhos` nunca pode ir abaixo de 0
- Se jogador tenta continue com 0 troféus, nega (spec: scenario 5, P1)

**Example Document**:

```json
{
  "id": "player_progress",
  "nivel_atual": 5,
  "pontuacao_total": 1250,
  "trofeus_ganhos": 3,
  "acertos_consecutivos": 7,
  "erros_consecutivos": 1,
  "timestamp_ultima_sincronizacao": "2026-05-16T10:00:00Z",
  "partida_ativa": null,
  "data_atualizacao": "2026-05-16T14:30:00Z"
}
```

---

### 3. Partida (Active Game)

**Purpose**: Armazena estado volatile de uma partida em andamento (qual
pergunta, histórico de respostas, erros nesta partida).

**Fields**:

| Field | Type | Constraints | Example |
|-------|------|-------------|---------|
| `id` | String | PK, UUID | "c0ffee00-0000-0000-0000-000000000001" |
| `nivel` | Integer | required, >= 1 | 5 |
| `acertos_neste_nivel` | Integer | required, [0–10] | 7 |
| `erros_consecutivos` | Integer | required, [0–3] | 1 |
| `pergunta_atual_id` | String | required, FK to Pergunta.id | "550e8400-e29b-41d4-a716-446655440000" |
| `letras_adivinhas` | Array<String> | required, each 1 char | ["R", "O", "M"] |
| `letras_erradas` | Array<String> | required, each 1 char | ["A"] |
| `historico_respostas` | Array<Object> | required (can be empty) | [{pergunta_id, resposta_dada, acertou, timestamp}] |
| `estado` | String | enum: ["em_andamento", "game_over", "nivel_completo"] | "em_andamento" |
| `data_criacao` | DateTime | required, RFC 3339 | "2026-05-16T14:00:00Z" |

**Lifecycle**:

- Criada quando jogador inicia jogo ou continua após Game Over
- Persisted em Hive/SQLite enquanto em andamento
- Deletada ou arquivada quando Game Over → continue/restart

**Example Document**:

```json
{
  "id": "c0ffee00-0000-0000-0000-000000000001",
  "nivel": 5,
  "acertos_neste_nivel": 7,
  "erros_consecutivos": 1,
  "pergunta_atual_id": "550e8400-e29b-41d4-a716-446655440000",
  "letras_adivinhas": ["R", "O", "M"],
  "letras_erradas": ["A"],
  "historico_respostas": [
    {
      "pergunta_id": "550e8400-e29b-41d4-a716-446655440000",
      "resposta_dada": "roma",
      "acertou": true,
      "timestamp": "2026-05-16T14:00:05Z"
    }
  ],
  "estado": "em_andamento",
  "data_criacao": "2026-05-16T14:00:00Z"
}
```

---

### 4. Trofeu (Trophy/Achievement)

**Purpose**: Representa um troféu ganho pelo jogador (para coleção e display).

**Fields**:

| Field | Type | Constraints | Example |
|-------|------|-------------|---------|
| `id` | String | PK, UUID | "trophy-first-10" |
| `tipo` | String | enum: ["milestone", "achievement", "comeback"] | "milestone" |
| `nome` | String | required, 2–30 chars | "First 10" |
| `descricao` | String | required, brief | "Acertou 10 perguntas no nível 1" |
| `data_ganho` | DateTime | required, RFC 3339 | "2026-05-16T14:05:00Z" |
| `icone_url` | String | optional, relative path ou URL | "assets/icons/trophy-first-10.png" |
| `pontos_bonus` | Integer | optional, >= 0 (bonus points se implementado) | 50 |

**Types**:

- **milestone**: Baseado em nível (p. ex., "Level 5 Master" ao atingir nível 5)
- **achievement**: Baseado em ação (p. ex., "Perfect Streak" sem erros em 5 perguntas)
- **comeback**: Resultado de usar continue (restaura nível/pontuação, custa 1 troféu)

**Cost Model**:

- Troféus ganhos (p. ex., milestone): additive
- Troféus gastos (continue): subtractive (1 por continue)

**Example Document**:

```json
{
  "id": "trophy-first-10",
  "tipo": "milestone",
  "nome": "First 10",
  "descricao": "Acertou 10 perguntas no nível 1",
  "data_ganho": "2026-05-16T14:05:00Z",
  "icone_url": "assets/icons/trophy-first-10.png",
  "pontos_bonus": 50
}
```

---

### 5. ConfiguracaoIdioma (Language Configuration)

**Purpose**: Armazena preferência de idioma do jogador.

**Fields**:

| Field | Type | Constraints | Example |
|-------|------|-------------|---------|
| `id` | String | PK, fixed: "language_config" | "language_config" |
| `idioma_preferido` | String | enum: ["pt_BR", "en", "it"] | "en" |
| `data_alteracao` | DateTime | required, RFC 3339 | "2026-05-16T14:30:00Z" |

**Fallback Logic**:

- Se chave de string não existe em `idioma_preferido`, usar `pt_BR`
- Nenhum erro lançado; graceful degradation (spec: SC-004, P3)

**Example Document**:

```json
{
  "id": "language_config",
  "idioma_preferido": "en",
  "data_alteracao": "2026-05-16T14:30:00Z"
}
```

---

## Storage & Persistence

### Hive Option (Recommended)

```dart
// Boxes
- 'perguntas': Box<PerguntaModel> (key: id)
- 'progresso': Box<ProgressoModel> (single doc, key: 'player_progress')
- 'partida_ativa': Box<PartidaModel> (key: id, or null if no active game)
- 'trofeus': Box<TrofeuModel> (key: id, multiple entries)
- 'config_idioma': Box<ConfigIdioma> (single doc, key: 'language_config')
```

**Advantages**:
- Offline-first optimized
- No schema migration complexity
- Key-value simplicity for this domain
- Good performance for 500–1000 items

### SQLite Option (Alternative)

```sql
-- Tables
CREATE TABLE perguntas (
  id TEXT PRIMARY KEY,
  pergunta TEXT NOT NULL,
  resposta TEXT NOT NULL,
  exibicao_resposta TEXT NOT NULL,
  categoria TEXT NOT NULL,
  dificuldade INTEGER NOT NULL CHECK (dificuldade BETWEEN 1 AND 10),
  contexto_historico TEXT NOT NULL CHECK (LENGTH(contexto_historico) <= 120),
  data_criacao TEXT NOT NULL
);

CREATE TABLE progresso (
  id TEXT PRIMARY KEY,
  nivel_atual INTEGER NOT NULL,
  pontuacao_total INTEGER NOT NULL,
  trofeus_ganhos INTEGER NOT NULL,
  acertos_consecutivos INTEGER NOT NULL,
  erros_consecutivos INTEGER NOT NULL,
  timestamp_ultima_sincronizacao TEXT NOT NULL,
  partida_ativa_id TEXT,
  data_atualizacao TEXT NOT NULL
);

CREATE TABLE partida (
  id TEXT PRIMARY KEY,
  nivel INTEGER NOT NULL,
  acertos_neste_nivel INTEGER NOT NULL,
  erros_consecutivos INTEGER NOT NULL,
  pergunta_atual_id TEXT NOT NULL REFERENCES perguntas(id),
  letras_adivinhas TEXT NOT NULL, -- JSON array as string
  letras_erradas TEXT NOT NULL,   -- JSON array as string
  historico_respostas TEXT NOT NULL, -- JSON array as string
  estado TEXT NOT NULL,
  data_criacao TEXT NOT NULL
);

CREATE TABLE trofeu (
  id TEXT PRIMARY KEY,
  tipo TEXT NOT NULL,
  nome TEXT NOT NULL,
  descricao TEXT NOT NULL,
  data_ganho TEXT NOT NULL,
  icone_url TEXT,
  pontos_bonus INTEGER
);

CREATE TABLE config_idioma (
  id TEXT PRIMARY KEY,
  idioma_preferido TEXT NOT NULL DEFAULT 'pt_BR',
  data_alteracao TEXT NOT NULL
);

-- Indexes
CREATE INDEX idx_pergunta_categoria ON perguntas(categoria);
CREATE INDEX idx_pergunta_dificuldade ON perguntas(dificuldade);
```

**Advantages**:
- Relational queries (filter by category, difficulty)
- ACID guarantees
- Scalable to many perguntas

---

## Synchronization Contract

**GitHub Source** (`perguntas.json`):

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "pergunta": "Qual é a capital da Itália?",
    "resposta": "roma",
    "exibicao_resposta": "Roma",
    "categoria": "geografia",
    "dificuldade": 5,
    "contexto_historico": "Roma foi fundada em 753 aC no Lácio.",
    "data_criacao": "2026-05-10T14:30:00Z"
  },
  ...
]
```

**Sync Behavior**:

1. Fetch `perguntas.json` a cada 24h ou quando nivel aumenta
2. Parse JSON, validar schema (required fields, types)
3. Check version hash (prevent duplicates)
4. Merge com local pool (additive, non-destructive)
5. Log any malformed entries (per spec: FR-009, SC-008)
6. Nunca sobrescrever progresso local

**Idempotence**:

- Same `id` → update (if newer `data_criacao`)
- Duplicate fetch → no-op (hash check)
- Network failure → retry next opportunity (24h or next level-up)

---

## Validation Rules

### Pergunta

- `id`: UUID format (v4 recommended)
- `pergunta`: 2–100 characters
- `resposta`: normalized (lowercase, no accents)
- `exibicao_resposta`: matches `resposta` in content, with accents
- `dificuldade`: integer [1–10]
- `contexto_historico`: 1–2 sentences, max 120 chars (per Q4)

### Progresso

- `nivel_atual`: >= 1
- `pontuacao_total`: >= 0
- `trofeus_ganhos`: >= 0
- `acertos_consecutivos`: [0–10]
- `erros_consecutivos`: [0–3]

### Partida

- All game state fields must be consistent (letras_adivinhas subset of resposta)
- `estado` must be valid enum value
- `pergunta_atual_id` must exist in Pergunta box/table

---

## Migration Strategy

**P1 → P2**: Adding `timestamp_ultima_sincronizacao` and sync logic
- Migrate existing `Progresso` documents (add field with current timestamp)
- No breaking changes to existing data

**P2 → P3**: Adding `ConfiguracaoIdioma`
- Create new box/table with default `pt_BR`
- No breaking changes

---

**Data Model Complete**. Ready for Phase 1 (contracts) and Phase 2 (tasks).
