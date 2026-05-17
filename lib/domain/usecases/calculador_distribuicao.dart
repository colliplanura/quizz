import '../entities/perfil_distribuicao_dificuldade.dart';

/// CalculadorDistribuicaoUseCase - Calcula e retorna a matriz de pesos por nível
/// Responsável por determinar a distribuição de dificuldade para cada nível de jogo
class CalculadorDistribuicao {
  /// Retorna perfil de distribuição para um nível específico
  PerfilDistribuicaoDificuldade obterPerfilParaNivel(int nivel) {
    final nivelNormalizado = nivel.clamp(1, 10);

    // Construir matriz de pesos de acordo com o nível
    final pesos = _construirPesosParaNivel(nivelNormalizado);

    return PerfilDistribuicaoDificuldade(
      nivelJogo: nivelNormalizado,
      pesosPorDificuldade: pesos,
      versaoPerfil: '1.0',
    );
  }

  /// Calcula distribuição ponderada progressiva por nível
  /// Níveis baixos (1-3): predominância de dificuldades baixas (1-3)
  /// Níveis médios (4-7): aderência progressiva ao nível
  /// Níveis altos (8-10): predominância de dificuldades altas (8-10)
  Map<int, int> _construirPesosParaNivel(int nivel) {
    final pesos = <int, int>{};

    if (nivel <= 3) {
      // Níveis iniciais: favorecer 1-3, com chance residual para outros
      pesos[1] = 10;
      pesos[2] = 10;
      pesos[3] = 10;
      pesos[4] = 2;
      pesos[5] = 2;
      pesos[6] = 2;
      pesos[7] = 2;
      pesos[8] = 1;
      pesos[9] = 1;
      pesos[10] = 1;
    } else if (nivel >= 8) {
      // Níveis avançados: favorecer 8-10, com chance residual para outros
      pesos[1] = 1;
      pesos[2] = 1;
      pesos[3] = 1;
      pesos[4] = 2;
      pesos[5] = 2;
      pesos[6] = 2;
      pesos[7] = 2;
      pesos[8] = 10;
      pesos[9] = 10;
      pesos[10] = 10;
    } else {
      // Níveis médios (4-7): distribuição progressiva baseada na distância
      for (int dif = 1; dif <= 10; dif++) {
        final distancia = (dif - nivel).abs();
        final peso = switch (distancia) {
          0 => 10,
          1 => 7,
          2 => 4,
          3 => 2,
          _ => 1,
        };
        pesos[dif] = peso;
      }
    }

    return pesos;
  }

  /// Retorna pesos normalizados (probabilidades) para cada dificuldade
  /// Útil para análise e verificação de distribuição
  Map<int, double> obterProbabilidadesParaNivel(int nivel) {
    final perfil = obterPerfilParaNivel(nivel);
    final pesosTotais = perfil.pesosPorDificuldade.values.fold<int>(
      0,
      (a, b) => a + b,
    );

    final probabilidades = <int, double>{};
    perfil.pesosPorDificuldade.forEach((dif, peso) {
      probabilidades[dif] = pesosTotais > 0 ? peso / pesosTotais : 0.0;
    });

    return probabilidades;
  }

  /// Valida se um perfil de distribuição é válido
  bool validarPerfil(PerfilDistribuicaoDificuldade perfil) {
    // Verificar se tem pesos para todas as dificuldades 1-10
    if (perfil.pesosPorDificuldade.keys.length != 10) {
      return false;
    }

    // Verificar se soma dos pesos > 0
    final soma = perfil.pesosPorDificuldade.values.fold<int>(
      0,
      (a, b) => a + b,
    );
    if (soma <= 0) {
      return false;
    }

    // Verificar se todas as dificuldades 1-10 estão presentes com peso > 0
    for (int dif = 1; dif <= 10; dif++) {
      if ((perfil.pesosPorDificuldade[dif] ?? 0) < 0) {
        return false;
      }
    }

    return true;
  }
}
