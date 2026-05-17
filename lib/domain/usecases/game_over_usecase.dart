import '../entities/configuracao_partida.dart';
import '../entities/partida.dart';
import '../repositories/progresso_repository.dart';
import '../../utils/constants.dart';

/// GameOverUseCase
/// Implementa a regra de game over: máximo de 5 erros consecutivos
///
/// Responsabilidades:
/// - Verificar se deve haver game over (5 erros)
/// - Finalizar a partida
/// - Determinar se o jogador pode continuar usando trofeus
class GameOverUseCase {
  GameOverUseCase({required ProgressoRepository progressoRepository})
    : _progressoRepository = progressoRepository;

  final ProgressoRepository _progressoRepository;

  /// Verifica se uma partida deve terminar por game over
  /// Retorna true se errosConsecutivos >= maxErrosConsecutivos
  static bool deveGamarOver(int errosConsecutivos) {
    return errosConsecutivos >= GameConstants.maxErrosConsecutivos;
  }

  /// Verifica se uma partida deve terminar por game over
  bool verificarGameOver(Partida partida) {
    return deveGamarOver(partida.errosConsecutivos);
  }

  /// Executa o game over: finaliza a partida e calcula se pode continuar
  ///
  /// Parâmetros:
  /// - partida: partida atual
  /// - configPartida: configuração da sessão (limites globais)
  ///
  /// Retorna:
  /// - partidaFinalizada: partida com estado = gameOver
  /// - podeContinuar: se o jogador tem trofeus para continuar
  Future<({Partida partidaFinalizada, bool podeContinuar})> executar(
    Partida partida,
    ConfiguracaoPartida configPartida,
  ) async {
    // Validar que realmente atingiu o limite
    if (!deveGamarOver(partida.errosConsecutivos)) {
      throw ArgumentError(
        'Game over só ocorre em ${configPartida.maxErrosConsecutivos} erros, '
        'mas há apenas ${partida.errosConsecutivos}',
      );
    }

    // Finalizar a partida com estado gameOver
    final partidaFinalizada = partida.copyWith(estado: EstadoPartida.gameOver);

    // Salvar a partida finalizada
    await _progressoRepository.salvarPartida(partidaFinalizada);

    // Determinar se pode continuar com trofeus
    // (Esta lógica será expandida em futuras fases)
    const podeContinuar =
        false; // Por enquanto, não há sistema de trofeus/continue

    return (partidaFinalizada: partidaFinalizada, podeContinuar: podeContinuar);
  }

  /// Incrementa o contador de erros consecutivos
  /// Se atingir o limite, retorna uma partida com estado gameOver
  ///
  /// Parâmetros:
  /// - partida: partida atual
  /// - configPartida: configuração da sessão
  ///
  /// Retorna:
  /// - novaPartida: partida com erro incrementado
  /// - terminou: true se atingiu game over
  ({Partida novaPartida, bool terminou}) incrementarErroConsecutivo(
    Partida partida,
    ConfiguracaoPartida configPartida,
  ) {
    final novoErros = partida.errosConsecutivos + 1;
    final terminou = deveGamarOver(novoErros);

    final novaPartida = partida.copyWith(
      errosConsecutivos: novoErros,
      estado: terminou ? EstadoPartida.gameOver : EstadoPartida.emAndamento,
    );

    return (novaPartida: novaPartida, terminou: terminou);
  }

  /// Reseta o contador de erros consecutivos quando o jogador acerta
  Partida resetarErrosConsecutivos(Partida partida) {
    return partida.copyWith(errosConsecutivos: 0);
  }
}
