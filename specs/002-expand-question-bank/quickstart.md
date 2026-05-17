# Quickstart: Expansão da Base de Perguntas

## Objetivo

Implementar a feature 002 com:

- catálogo inicial de 1000 perguntas
- distribuição adaptativa por nível
- anti-repetição por 2h em tempo corrido
- ajuste de game over para 5 erros consecutivos

## Pré-requisitos

- Flutter e Dart instalados
- Dependências do projeto resolvidas
- Branch ativa da feature: 002-create-new-spec

## Passo a passo

1. Preparar dados

- criar/validar arquivo de catálogo com 1000 perguntas
- garantir no mínimo 10 categorias e 50 perguntas por categoria
- validar dificuldade entre 1 e 10 para todos os itens

1. Atualizar regras de domínio

- ajustar constante de erros máximos para 5
- adicionar regra de anti-repetição por janela de 2 horas wall-clock
- implementar fallback de reset do histórico quando pool elegível esgotar

1. Implementar seleção adaptativa

- definir matriz de pesos por nível para dificuldades 1..10
- aplicar sorteio aleatório no conjunto elegível
- em conflito, priorizar anti-repetição + aleatoriedade

1. Persistência local

- salvar histórico de perguntas respondidas com timestamp wall-clock
- restaurar histórico ao reabrir app

1. Testes mínimos

- unit: validação de catálogo (1000, categorias, dificuldade)
- unit: elegibilidade por anti-repetição (2h)
- unit: fallback por pool vazio
- unit: distribuição ponderada por nível
- unit: game over no 5º erro
- integration: reabertura de sessão preserva regras

## Comandos úteis

- flutter analyze
- flutter test test/unit/
- flutter test test/integration/

## Resultado esperado

- perguntas com curva de dificuldade progressiva
- ausência de repetição dentro de 2h, salvo fallback por pool vazio
- experiência menos punitiva com 5 erros para game over
- cobertura de testes de regras centrais mantendo confiabilidade
