import 'dart:math';

/// Utilidade para seleção aleatória ponderada
/// Implementa algoritmo de roda de roleta com distribuição ponderada
class WeightedRandomSelector<T> {
  WeightedRandomSelector({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Seleciona um item da lista com base em pesos fornecidos
  ///
  /// [items] - Lista de itens a selecionar
  /// [weights] - Lista de pesos correspondentes aos itens
  /// Retorna um item selecionado aleatoriamente com base na distribuição de pesos
  ///
  /// Lança [ArgumentError] se as listas tiverem tamanhos diferentes ou estiverem vazias
  T select(List<T> items, List<double> weights) {
    if (items.isEmpty || weights.isEmpty) {
      throw ArgumentError('Items e weights não podem estar vazios');
    }

    if (items.length != weights.length) {
      throw ArgumentError(
        'Items (${items.length}) e weights (${weights.length}) devem ter o mesmo tamanho',
      );
    }

    if (weights.every((w) => w <= 0)) {
      throw ArgumentError('Pelo menos um peso deve ser maior que 0');
    }

    final acumulado = _calcularPesosAcumulados(weights);
    final alvo = _random.nextDouble() * (acumulado.last);

    // Busca binária para encontrar o índice
    var indice = 0;
    for (int i = 0; i < acumulado.length; i++) {
      if (alvo <= acumulado[i]) {
        indice = i;
        break;
      }
    }

    return items[indice];
  }

  /// Seleciona múltiplos itens da lista com base em pesos fornecidos
  /// Permite repetição (com reposição)
  ///
  /// [items] - Lista de itens a selecionar
  /// [weights] - Lista de pesos correspondentes aos itens
  /// [count] - Número de itens a selecionar
  /// Retorna lista de itens selecionados aleatoriamente
  List<T> selectMultiple(List<T> items, List<double> weights, int count) {
    final resultado = <T>[];
    for (int i = 0; i < count; i++) {
      resultado.add(select(items, weights));
    }
    return resultado;
  }

  /// Calcula pesos acumulados (cumulative distribution)
  List<double> _calcularPesosAcumulados(List<double> weights) {
    final acumulado = <double>[];
    var soma = 0.0;

    for (final peso in weights) {
      soma += peso;
      acumulado.add(soma);
    }

    return acumulado;
  }

  /// Retorna as probabilidades normalizadas para cada item
  /// Útil para análise e verificação de distribuição
  List<double> calcularprobabilidades(List<double> weights) {
    final total = weights.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return List.filled(weights.length, 0.0);
    return weights.map((w) => w / total).toList();
  }
}
