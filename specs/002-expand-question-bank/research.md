# Research: Expansão da Base de Perguntas

**Feature**: 002-expand-question-bank  
**Date**: 2026-05-16  
**Status**: Concluído

## Decisão 1: Distribuição de dificuldade por nível

**Decision**: Aplicar distribuição ponderada progressiva por nível, com chance residual para faixas fora da predominante.

**Rationale**: Mantém curva de aprendizagem mais suave nos níveis iniciais e aumenta desafio nos níveis avançados sem tornar o sorteio determinístico.

**Alternatives considered**:

- Faixas rígidas por bloco (1-3, 4-7, 8-10): previsível, porém rígido.
- Dificuldade única por nível: simples, porém reduz variedade e aumenta risco de pool insuficiente.
- Distribuição uniforme: não atende progressão justa.

## Decisão 2: Regra de anti-repetição

**Decision**: Não repetir pergunta respondida nas próximas 2 horas em tempo de relógio corrido (wall-clock), inclusive com app fechado.

**Rationale**: A regra é objetiva, fácil de auditar e não depende de cálculo de tempo ativo de sessão.

**Alternatives considered**:

- Tempo ativo de partida: mais complexo e sujeito a inconsistência em background/foreground.
- Janela por quantidade de perguntas: não reflete requisito temporal.

## Decisão 3: Fallback quando pool elegível esgota

**Decision**: Ao esgotar pool por causa da anti-repetição, limpar histórico recente e retomar sorteio normal imediatamente.

**Rationale**: Evita bloqueio de gameplay e mantém experiência contínua mesmo em sessões longas.

**Alternatives considered**:

- Bloquear partida até surgir pool elegível: inviável para UX.
- Ignorar anti-repetição por 1 sorteio: regra menos previsível.
- Liberar apenas item mais antigo: melhor preservação, porém maior complexidade operacional.

## Decisão 4: Prioridade em conflito de regras

**Decision**: Priorizar anti-repetição e aleatoriedade; na falta de faixa ideal, permitir qualquer dificuldade elegível.

**Rationale**: Preserva novidade e continuidade de jogo, reduzindo risco de travamento por filtro excessivo.

**Alternatives considered**:

- Priorizar estritamente dificuldade-alvo: aumenta risco de pool vazio.
- Sorteio uniforme irrestrito: degrada progressão.

## Decisão 5: Variedade temática mínima

**Decision**: Exigir no mínimo 10 categorias, com ao menos 50 perguntas válidas por categoria, totalizando 1000.

**Rationale**: Define critério verificável de variedade e evita concentração indevida em poucos temas.

**Alternatives considered**:

- Apenas ausência de duplicidade: insuficiente para garantir variedade.
- Muitas categorias sem mínimo por categoria: pode gerar distribuição artificial.

## Decisão 6: Limite de erros consecutivos

**Decision**: Alterar limite de game over de 3 para 5 erros consecutivos.

**Rationale**: Torna a experiência menos punitiva para jogadores iniciantes e aumenta tempo de engajamento por rodada.

**Alternatives considered**:

- Manter 3 erros: maior dificuldade, menor tolerância para aprendizagem.
- Valores acima de 5: pode reduzir tensão da mecânica de forca.
