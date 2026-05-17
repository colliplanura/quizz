import 'package:equatable/equatable.dart';

/// PerfilDistribuicaoDificuldade - Matriz de pesos para seleção por nível
class PerfilDistribuicaoDificuldade extends Equatable {
  final int nivelJogo;
  final Map<int, int> pesosPorDificuldade; // chaves 1..10, valores = pesos
  final String versaoPerfil;

  const PerfilDistribuicaoDificuldade({
    required this.nivelJogo,
    required this.pesosPorDificuldade,
    required this.versaoPerfil,
  });

  @override
  List<Object?> get props => [nivelJogo, pesosPorDificuldade, versaoPerfil];
}
