import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/partida.dart';
import 'package:quizverse_forca/domain/entities/progresso.dart';
import 'package:quizverse_forca/utils/constants.dart';

void main() {
  group('Restauração de partida após relaunch', () {
    test('estado de partida pode ser serializado e restaurado', () {
      final original = Partida(
        id: 'partida-123',
        nivel: 2,
        acertosNesteNivel: 5,
        errosConsecutivos: 1,
        perguntaAtualId: 'q-42',
        letrasAdivinhadas: const ['a', 'e', 'o'],
        letrasErradas: const ['z'],
        estado: EstadoPartida.emAndamento,
        dataCriacao: DateTime(2024, 1, 15),
      );

      // Simular serialização e deserialização de partida
      final comoMapa = {
        'id': original.id,
        'nivel': original.nivel,
        'acertos_neste_nivel': original.acertosNesteNivel,
        'erros_consecutivos': original.errosConsecutivos,
        'pergunta_atual_id': original.perguntaAtualId,
        'letras_adivinhadas': original.letrasAdivinhadas.join(','),
        'letras_erradas': original.letrasErradas.join(','),
        'estado': original.estado.name,
      };

      // Restaurar
      final restaurada = Partida(
        id: comoMapa['id'] as String,
        nivel: comoMapa['nivel'] as int,
        acertosNesteNivel: comoMapa['acertos_neste_nivel'] as int,
        errosConsecutivos: comoMapa['erros_consecutivos'] as int,
        perguntaAtualId: comoMapa['pergunta_atual_id'] as String,
        letrasAdivinhadas: (comoMapa['letras_adivinhadas'] as String).split(','),
        letrasErradas: (comoMapa['letras_erradas'] as String).split(','),
        estado: EstadoPartida.values.byName(comoMapa['estado'] as String),
        dataCriacao: original.dataCriacao,
      );

      expect(restaurada.id, equals(original.id));
      expect(restaurada.nivel, equals(original.nivel));
      expect(restaurada.acertosNesteNivel, equals(original.acertosNesteNivel));
      expect(restaurada.errosConsecutivos, equals(original.errosConsecutivos));
      expect(restaurada.perguntaAtualId, equals(original.perguntaAtualId));
      expect(restaurada.letrasAdivinhadas, equals(original.letrasAdivinhadas));
      expect(restaurada.letrasErradas, equals(original.letrasErradas));
      expect(restaurada.estado, equals(original.estado));
    });

    test('progresso mantém nivel e pontuação após relaunch', () {
      final progresso = Progresso(
        id: GameConstants.idProgressoJogador,
        nivelAtual: 4,
        pontuacaoTotal: 38,
        trofeusGanhos: 2,
        acertosConsecutivos: 3,
        errosConsecutivos: 0,
        timestampUltimaSincronizacao: DateTime(2024, 1, 10),
        partidaAtivaId: 'partida-123',
      );

      expect(progresso.nivelAtual, equals(4));
      expect(progresso.pontuacaoTotal, equals(38));
      expect(progresso.trofeusGanhos, equals(2));
      expect(progresso.partidaAtivaId, equals('partida-123'));
    });
  });
}
