# Data Model: Expansão da Base de Perguntas

**Feature**: 002-expand-question-bank  
**Date**: 2026-05-16

**Nota**: Este documento é a fonte de verdade para nomes formais de entidades, schemas e validações. Referências em [`spec.md`](spec.md) usam os nomes técnicos definidos aqui.

## Visão Geral

Esta feature estende o modelo existente para suportar:

- base inicial de 1000 perguntas com variedade temática mínima
- sorteio por distribuição ponderada progressiva
- anti-repetição por janela temporal de 2 horas (wall-clock)
- limite de game over ajustado para 5 erros consecutivos

## Entidades

### 1. PerguntaCatalogo

Representa uma pergunta do banco inicial/sincronizado.

Campos:

- id: string, obrigatório, único
- enunciado: string, obrigatório
- respostaNormalizada: string, obrigatório
- respostaExibicao: string, obrigatório
- categoria: string, obrigatório
- dificuldade: int, obrigatório, intervalo 1..10
- contexto: map idioma->texto (pt-BR obrigatório)
- origem: enum {embarcado, sincronizado}
- criadoEm: datetime opcional

Validações:

- dificuldade entre 1 e 10
- categoria não vazia
- total geral alvo: 1000
- regra de variedade: pelo menos 10 categorias com mínimo 50 perguntas cada

### 2. PerfilDistribuicaoDificuldade

Define a matriz de pesos de sorteio por nível do jogador.

Campos:

- nivelJogo: int, obrigatório
- pesosPorDificuldade: map<int,int>, obrigatório (chaves 1..10)
- versaoPerfil: string, obrigatório

Regras:

- soma dos pesos > 0
- níveis iniciais favorecem 1..3
- níveis avançados favorecem 8..10
- mantém pesos residuais para demais faixas

### 3. HistoricoPerguntaRespondida

Registro utilizado para aplicar anti-repetição.

Campos:

- perguntaId: string, obrigatório
- respondidaEm: datetime wall-clock, obrigatório
- jogadorId: string local (ou chave fixa de progresso), obrigatório

Regras:

- pergunta é inelegível se now - respondidaEm < 2h
- se pool elegível ficar vazio, limpar histórico e recalcular sorteio
- persistência local obrigatória para sobreviver a restart do app

### 4. ConfiguracaoPartida

Parâmetros globais das regras da rodada.

Campos:

- maxErrosConsecutivos: int (valor alvo: 5)
- janelaAntiRepeticaoHoras: int (valor alvo: 2)
- versaoRegras: string

Regras:

- game over apenas ao atingir 5 erros consecutivos
- deve coexistir com regras já existentes de pontuação e nível

## Relacionamentos

- PerguntaCatalogo (1) <- (N) HistoricoPerguntaRespondida por perguntaId.
- PerfilDistribuicaoDificuldade (1 por nível) influencia seleção de PerguntaCatalogo.
- ConfiguracaoPartida define limites globais aplicados ao estado de Partida.

## Transições de Estado Relevantes

- Seleção de pergunta:

  1. filtrar por anti-repetição (2h)
  2. aplicar pesos por dificuldade do nível atual
  3. sortear aleatoriamente no conjunto elegível
  4. se conjunto vazio, limpar histórico e repetir fluxo

- Erro do jogador:

  1. incrementar erros consecutivos
  2. se erros == 5, emitir game over

## Notas de Migração

- Trocar constante de erros máximos de 3 para 5.
- Adicionar/estender armazenamento local para histórico temporal de perguntas respondidas.
- Validar integridade da base inicial para garantir 1000 itens e regra de categorias.
