import '../entities/partida.dart';
import '../entities/progresso.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';

class CheckAnswer {
  ({Partida partida, Progresso progresso, bool acertou}) executar({
    required Partida partida,
    required Progresso progresso,
    required String respostaNormalizada,
    required String letrasDigitadas,
  }) {
    final letraLimpa = letrasDigitadas.trim().toLowerCase();
    if (!Validators.letraValida(letraLimpa)) {
      return (partida: partida, progresso: progresso, acertou: false);
    }

    final letraNorm = Validators.normalizarResposta(letraLimpa);
    final jaAdivinhada = partida.letrasAdivinhadas.contains(letraNorm) ||
        partida.letrasErradas.contains(letraNorm);
    if (jaAdivinhada) {
      return (partida: partida, progresso: progresso, acertou: false);
    }

    final acertou = respostaNormalizada.contains(letraNorm);
    late Partida novaPartida;
    late Progresso novoProgresso;

    if (acertou) {
      final novasLetras = [...partida.letrasAdivinhadas, letraNorm];
      final palavraCompleta = respostaNormalizada
          .split('')
          .every((c) => novasLetras.contains(c) || c == ' ');

      novaPartida = partida.copyWith(
        letrasAdivinhadas: novasLetras,
        errosConsecutivos: 0,
        acertosNesteNivel: palavraCompleta
            ? partida.acertosNesteNivel + 1
            : partida.acertosNesteNivel,
        estado: palavraCompleta &&
                partida.acertosNesteNivel + 1 >= GameConstants.acertosPorNivel
            ? EstadoPartida.nivelCompleto
            : EstadoPartida.emAndamento,
      );

      novoProgresso = progresso.copyWith(
        pontuacaoTotal: progresso.pontuacaoTotal + 1,
        acertosConsecutivos: progresso.acertosConsecutivos + (palavraCompleta ? 1 : 0),
        errosConsecutivos: 0,
      );
    } else {
      final novosErros = partida.errosConsecutivos + 1;
      novaPartida = partida.copyWith(
        letrasErradas: [...partida.letrasErradas, letraNorm],
        errosConsecutivos: novosErros,
        estado: novosErros >= GameConstants.maxErrosConsecutivos
            ? EstadoPartida.gameOver
            : EstadoPartida.emAndamento,
      );
      novoProgresso = progresso.copyWith(
        errosConsecutivos: progresso.errosConsecutivos + 1,
        acertosConsecutivos: 0,
      );
    }

    return (partida: novaPartida, progresso: novoProgresso, acertou: acertou);
  }
}
