# Relatorio de Performance - Feature 002

## Metas

- p95 de sorteio + carregamento <= 200ms
- Distribuicao por nivel com aderencia minima de 70% para faixas alvo

## Evidencias executadas

- test/integration/test_catalog_load_performance.dart
- test/benchmark/benchmark_distribuicao.dart

## Resultado esperado

- Carregamento de catalogo com p95 abaixo de 200ms
- Selecao por nivel baixo (1..3) com >=70% de dificuldades 1..3
- Selecao por nivel alto (8..10) com >=70% de dificuldades 8..10

## Resultado observado

- test/integration/test_catalog_load_performance.dart: PASS
  - p95 de carregamento observado: 5ms
- test/benchmark/benchmark_distribuicao.dart: PASS
  - aderencia faixa baixa (niveis 1..3): 73.00%
  - aderencia faixa alta (niveis 8..10): 73.67%
  - p95 por operacao de sorteio: <= 200ms

## Observacoes

- Este relatorio e atualizado com os resultados reais apos execucao dos testes.
- Todos os valores observados ficaram dentro das metas definidas na feature 002.
