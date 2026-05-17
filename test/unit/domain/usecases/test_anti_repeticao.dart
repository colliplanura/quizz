import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/utils/constants.dart';

/// Teste unitário de anti-repetição (elegibilidade em 2h wall-clock)
/// Valida que uma pergunta respondida há menos de 2 horas não é elegível

Pergunta _perguntaTeste({String? id, int dificuldade = 1}) {
  return Pergunta(
    id: id ?? 'q-${DateTime.now().millisecondsSinceEpoch}',
    pergunta: 'Pergunta teste',
    resposta: 'resposta',
    exibicaoResposta: 'Resposta Exibida',
    categoria: 'teste',
    dificuldade: dificuldade,
    contextoHistorico: const {'pt_BR': 'Contexto teste'},
    dataCriacao: DateTime(2026, 5, 17),
  );
}

bool _perguntaElegivel({
  required String perguntaId,
  required Map<String, DateTime> historico,
  required DateTime referencia,
  required Duration janela,
}) {
  if (!historico.containsKey(perguntaId)) {
    return true; // Pergunta nunca respondida é elegível
  }

  final respondidaEm = historico[perguntaId]!;
  final tempoDecorrido = referencia.difference(respondidaEm);
  return tempoDecorrido >= janela;
}

void main() {
  group('AntiRepeticao - Elegibilidade por 2h Wall-Clock', () {
    test('pergunta nunca respondida é sempre elegível', () async {
      final historico = <String, DateTime>{};
      final pergunta = _perguntaTeste(id: 'q-nova');
      final agora = DateTime.now();

      final elegivel = _perguntaElegivel(
        perguntaId: pergunta.id,
        historico: historico,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
      );

      expect(elegivel, isTrue);
    });

    test('pergunta respondida há 1h é inelegível', () async {
      final agora = DateTime.now();
      final respondidaEm = agora.subtract(const Duration(hours: 1));
      final historico = <String, DateTime>{'q-1': respondidaEm};

      final elegivel = _perguntaElegivel(
        perguntaId: 'q-1',
        historico: historico,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
      );

      expect(elegivel, isFalse);
    });

    test('pergunta respondida há 2h é elegível (limite exato)', () async {
      final agora = DateTime.now();
      final respondidaEm = agora.subtract(const Duration(hours: 2));
      final historico = <String, DateTime>{'q-1': respondidaEm};

      final elegivel = _perguntaElegivel(
        perguntaId: 'q-1',
        historico: historico,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
      );

      expect(elegivel, isTrue);
    });

    test(
      'pergunta respondida há 2h 1min é elegível (além da janela)',
      () async {
        final agora = DateTime.now();
        final respondidaEm = agora.subtract(
          const Duration(hours: 2, minutes: 1),
        );
        final historico = <String, DateTime>{'q-1': respondidaEm};

        final elegivel = _perguntaElegivel(
          perguntaId: 'q-1',
          historico: historico,
          referencia: agora,
          janela: GameConstants.janelaAntiRepeticao,
        );

        expect(elegivel, isTrue);
      },
    );

    test('pergunta respondida há 30min é inelegível', () async {
      final agora = DateTime.now();
      final respondidaEm = agora.subtract(const Duration(minutes: 30));
      final historico = <String, DateTime>{'q-1': respondidaEm};

      final elegivel = _perguntaElegivel(
        perguntaId: 'q-1',
        historico: historico,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
      );

      expect(elegivel, isFalse);
    });

    test(
      'histórico com múltiplas perguntas filtra inelegíveis corretamente',
      () async {
        final agora = DateTime.now();
        final historico = <String, DateTime>{
          'q-1': agora.subtract(const Duration(minutes: 30)), // inelegível
          'q-2': agora.subtract(
            const Duration(hours: 1, minutes: 30),
          ), // inelegível
          'q-3': agora.subtract(
            const Duration(hours: 2, minutes: 30),
          ), // elegível
          'q-4': agora.subtract(const Duration(hours: 3)), // elegível
        };

        final elegiveisIds = historico.entries
            .where(
              (entry) => _perguntaElegivel(
                perguntaId: entry.key,
                historico: historico,
                referencia: agora,
                janela: GameConstants.janelaAntiRepeticao,
              ),
            )
            .map((e) => e.key)
            .toList();

        expect(elegiveisIds, containsAll(['q-3', 'q-4']));
        expect(elegiveisIds, isNot(contains('q-1')));
        expect(elegiveisIds, isNot(contains('q-2')));
      },
    );

    test('janela de anti-repetição é exatamente 2 horas', () {
      expect(
        GameConstants.janelaAntiRepeticao,
        equals(const Duration(hours: 2)),
      );
    });
  });
}
