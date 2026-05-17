# Contract: Catálogo de Perguntas e Regras de Seleção

**Feature**: 002-expand-question-bank  
**Date**: 2026-05-16

## Objetivo

Definir o contrato funcional para:

- estrutura mínima da pergunta
- critérios de elegibilidade
- algoritmo de seleção aleatória adaptativa por nível
- regra de anti-repetição de 2 horas

## Estrutura mínima da pergunta

Formato lógico obrigatório por item:

- id: string único
- enunciado: string
- resposta_normalizada: string
- resposta_exibicao: string
- categoria: string
- dificuldade: inteiro de 1 a 10
- contexto: objeto de localização

## Regras de qualidade do catálogo

- total de perguntas válidas: exatamente 1000
- mínimo de 10 categorias
- mínimo de 50 perguntas válidas por categoria
- nenhuma duplicidade por id

## Elegibilidade para sorteio

Uma pergunta é elegível quando:

1. está válida no catálogo
2. não foi respondida nas últimas 2 horas (wall-clock)

Se nenhuma pergunta for elegível:

1. limpar histórico recente
2. recalcular elegibilidade
3. realizar sorteio normal

## Distribuição adaptativa por nível

- deve existir uma matriz de pesos por nível para dificuldades 1..10
- níveis iniciais: predominância de dificuldades baixas
- níveis avançados: predominância de dificuldades altas
- manter chance residual para demais dificuldades

## Prioridade de regras

Ordem de prioridade em conflitos:

1. anti-repetição
2. aleatoriedade no conjunto elegível
3. aderência à faixa de dificuldade alvo

Consequência: na falta de faixa ideal, qualquer dificuldade elegível pode ser sorteada.

## Regra de término por erro

- game over ocorre ao atingir 5 erros consecutivos
- valores abaixo de 5 mantêm partida ativa

## Cenários mínimos de validação

1. Catálogo com 1000 perguntas válidas passa na validação.
2. Catálogo com menos de 10 categorias falha.
3. Pergunta respondida há menos de 2h não é elegível.
4. Pool vazio dispara reset de histórico e permite novo sorteio.
5. Em nível inicial, distribuição favorece dificuldades baixas.
6. Em nível avançado, distribuição favorece dificuldades altas.
7. Game over somente no 5º erro consecutivo.
