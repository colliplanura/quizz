# API Contract: GitHub Question Source

**Phase**: Phase 1 (Design)  
**Date**: 2026-05-16  
**Status**: Final

---

## Overview

Este contrato define a interface esperada para a fonte de perguntas do GitHub.
O arquivo `perguntas.json` no repositório `github.com/colliplanura/quizz` é a
fonte única de verdade (per Princípio V, spec: FR-002).

---

## Endpoint

```
GET https://raw.githubusercontent.com/colliplanura/quizz/main/perguntas.json
```

Alternativa (rota de branches):
```
GET https://raw.githubusercontent.com/colliplanura/quizz/refs/heads/main/perguntas.json
```

---

## Request

**Method**: `GET`  
**Headers**:
- `User-Agent: QuizVerse:Forca/1.0` (recommended, identifies client)
- `Accept: application/json`
- `Accept-Encoding: gzip` (optional, GitHub supports compression)

**Query Parameters**: None

**Body**: Empty

**Timeout**: 30 seconds (per production best practices)  
**Retry**: 3 attempts with exponential backoff (2s, 4s, 8s) if network failure

---

## Response

### Success (200 OK)

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
  {
    "id": "660e8400-e29b-41d4-a716-446655440001",
    "pergunta": "Qual é o maior planeta do nosso sistema solar?",
    "resposta": "jupiter",
    "exibicao_resposta": "Júpiter",
    "categoria": "ciência",
    "dificuldade": 3,
    "contexto_historico": "Júpiter é o maior planeta, 11x maior que Terra.",
    "data_criacao": "2026-05-11T09:00:00Z"
  }
]
```

**Content-Type**: `application/json; charset=utf-8`

**Headers**:
- `Cache-Control: public, max-age=3600` (cached for 1 hour by GitHub)
- `Content-Length: <bytes>`
- `Last-Modified: <RFC 2822 date>` (used for idempotence check)

### Error Responses

**404 Not Found** (file deleted or wrong path):
```json
null
```
→ App logs error, retries next opportunity (24h or next level-up)

**403 Forbidden** (rate limit exceeded):
```json
{
  "message": "API rate limit exceeded",
  "documentation_url": "https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#rate-limiting"
}
```
→ App waits 1 hour, retries

**500 Server Error**:
→ App retries with backoff

---

## Schema

Each question object MUST comply with this schema:

```json
{
  "type": "array",
  "items": {
    "type": "object",
    "required": ["id", "pergunta", "resposta", "exibicao_resposta", "categoria", "dificuldade", "contexto_historico"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
        "description": "UUID v4"
      },
      "pergunta": {
        "type": "string",
        "minLength": 2,
        "maxLength": 100,
        "description": "Question text"
      },
      "resposta": {
        "type": "string",
        "minLength": 1,
        "maxLength": 50,
        "pattern": "^[a-z0-9\\-]+$",
        "description": "Normalized answer (lowercase, no accents)"
      },
      "exibicao_resposta": {
        "type": "string",
        "minLength": 1,
        "maxLength": 50,
        "description": "Display answer (with accents)"
      },
      "categoria": {
        "type": "string",
        "enum": ["história", "geografia", "ciência", "cultura", "outro"]
      },
      "dificuldade": {
        "type": "integer",
        "minimum": 1,
        "maximum": 10,
        "description": "Difficulty level"
      },
      "contexto_historico": {
        "type": "string",
        "minLength": 10,
        "maxLength": 120,
        "description": "Educational context (1-2 sentences, per clarification Q4)"
      },
      "data_criacao": {
        "type": "string",
        "format": "date-time",
        "description": "RFC 3339 timestamp"
      }
    }
  }
}
```

---

## Validation Rules (App-side)

When fetching and parsing:

1. **Schema Validation**:
   - JSON must be valid array
   - Each object must have all required fields
   - Types must match schema (string, integer, etc.)
   - Enum values must be exact

2. **Field Validation**:
   - `id`: UUID v4 format
   - `pergunta`: 2–100 chars (truncate UI if needed)
   - `resposta`: lowercase, no accents, 1–50 chars
   - `exibicao_resposta`: match resposta semantically, with accents
   - `dificuldade`: 1–10 (reject if outside range)
   - `contexto_historico`: 1–2 sentences, max 120 chars
     - If > 120 chars: truncate with "...", log warning, but accept (graceful degradation)

3. **Uniqueness**:
   - Reject duplicates (same `id` → update local if newer `data_criacao`)
   - Check version hash to prevent re-processing

4. **Malformed Entries**:
   - Log entry with error details
   - Skip entry (don't add to cache)
   - Continue processing rest of array
   - Notify user only if ALL entries malformed (no questions loaded)

---

## Sync Strategy

### Trigger Points

1. **App Launch**:
   - If >= 24 hours since `timestamp_ultima_sincronizacao` → fetch
   - If no `timestamp_ultima_sincronizacao` → fetch immediately

2. **Level Up**:
   - Whenever `nivel_atual` increases → dispatch background sync task
   - Don't block level celebration (async)

### Idempotence

- Use `Last-Modified` header + local version hash
- If fetch returns same content → no-op (no local update)
- If network failure → log, schedule retry, don't corrupt local

### Merge Logic

```pseudo
new_questions = fetch_from_github()
for q in new_questions:
  existing = local_db.find_by_id(q.id)
  if existing:
    if q.data_criacao > existing.data_criacao:
      update local[q.id] with q
  else:
    insert q into local
```

### Constraints

- No question is ever deleted (only added/updated)
- Progresso local never touched during sync
- If sync fails → log, retry next opportunity
- Pool size target: 500–1000 questions (per clarificação Q3)

---

## Rate Limiting

GitHub's rate limits for unauthenticated requests:

- **Limit**: 60 requests/hour per IP
- **Reset**: Every hour
- **Check**: `X-RateLimit-Remaining` header

**App Handling**:
- If rate limit hit → wait 1 hour, retry
- If no auth token → clearly document in README (users can provide token to increase limit)
- Typical use case (1 sync per 24h) never hits limit

---

## Example cURL

```bash
curl -i \
  -H "User-Agent: QuizVerse:Forca/1.0" \
  -H "Accept: application/json" \
  -H "Accept-Encoding: gzip" \
  https://raw.githubusercontent.com/colliplanura/quizz/main/perguntas.json
```

---

## Example Dart Implementation (Pseudo-code)

```dart
class GitHubClient {
  Future<List<PerguntaModel>> fetchQuestions() async {
    const String url =
        'https://raw.githubusercontent.com/colliplanura/quizz/main/perguntas.json';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'QuizVerse:Forca/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => PerguntaModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 404) {
        logger.warning('perguntas.json not found');
        return [];
      } else {
        logger.warning('GitHub sync failed: ${response.statusCode}');
        throw Exception('HTTP ${response.statusCode}');
      }
    } on TimeoutException {
      logger.warning('GitHub sync timeout');
      rethrow;
    } catch (e) {
      logger.error('GitHub sync error: $e');
      rethrow;
    }
  }

  Future<void> mergeQuestions(List<PerguntaModel> newQuestions) async {
    for (final q in newQuestions) {
      await perguntaBox.put(q.id, q);
    }
    await progressoBox.update('player_progress',
        (p) => p.copyWith(
              timestampUltimaSincronizacao: DateTime.now(),
            ));
  }
}
```

---

## Testing

**Contract Tests** (verify API compliance):
- Mock GitHub response (valid JSON array)
- Parse and validate schema
- Reject malformed entries (missing fields, wrong types)
- Test idempotence (same fetch twice → same local state)

**Integration Tests** (verify sync flow):
- Fetch on app launch (if 24h elapsed)
- Fetch on level up (async, non-blocking)
- Network failure → graceful retry
- No data corruption on crash during sync

---

**API Contract Complete**. Ready for Phase 2 (implementation).
