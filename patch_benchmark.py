import os
path = 'test/benchmark/benchmark_distribuicao.dart'
with open(path, 'r') as f:
    content = f.read()

content = content.replace(
    'final pAlto = _percentualFaixa(alto, 8, 10);',
    'final pAlto = _percentualFaixa(alto, 8, 10); print("METRIC_pBaixo: $pBaixo%, METRIC_pAlto: $pAlto%");'
)
content = content.replace(
    'final p95 = _p95(amostras);',
    'final p95 = _p95(amostras); print("METRIC_p95: ${p95.inMilliseconds}ms");'
)

with open(path, 'w') as f:
    f.write(content)
