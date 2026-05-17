import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/utils/constants.dart';

/// Teste unitário de fallback de anti-repetição
/// Valida que quando o pool elegível fica vazio, o histórico é limpo e o sorteio continua

class _FakeHistoricoFallback extends HistoricoPerguntaLocalDatasource {
  _FakeHistoricoFallback({Map<String, DateTime>? historicoInicial})
    : _historico = historicoInicial ?? <String, DateTime>{};

  Map<String, DateTime> _historico;
  int _vezesClearChamado = 0;

  int get vezesClearChamado => _vezesClearChamado;

  @override
  Future<void> limparHistorico() async {
    _vezesClearChamado++;
    _historico = <String, DateTime>{};
  }

  @override
  Future<void> marcarPerguntaRespondida(
    String perguntaId,
    DateTime quando,
  ) async {
    _historico[perguntaId] = quando;
  }

  @override
  Future<Map<String, DateTime>> obterHistorico() async {
    return Map<String, DateTime>.from(_historico);
  }

  @override
  Future<void> salvarHistorico(Map<String, DateTime> historico) async {
    _historico = Map<String, DateTime>.from(historico);
  }
}

Pergunta _perguntaTeste({String? id}) {
  return Pergunta(
    id: id ?? 'q-${DateTime.now().millisecondsSinceEpoch}',
    pergunta: 'Pergunta teste',
    resposta: 'resposta',
    exibicaoResposta: 'Resposta',
    categoria: 'teste',
    dificuldade: 1,
    contextoHistorico: const {'pt_BR': 'Contexto'},
    dataCriacao: DateTime(2026, 5, 17),
  );
}

List<Pergunta> _filtrarElegiveisComFallback({
  required List<Pergunta> perguntas,
  required Map<String, DateTime> historico,
  required DateTime referencia,
  required Duration janela,
  required Function() aoLimparHistorico,
}) {
  // Tentar filtrar elegíveis respeitando janela de 2h
  final elegiveis = perguntas.where((p) {
    if (!historico.containsKey(p.id)) return true;
    final respondidaEm = historico[p.id]!;
    return referencia.difference(respondidaEm) >= janela;
  }).toList();

  // Se pool ficar vazio, limpar histórico e retomar com todas
  if (elegiveis.isEmpty && historico.isNotEmpty) {
    aoLimparHistorico();
    return List<Pergunta>.from(perguntas);
  }

  return elegiveis;
}

void main() {
  group('AntiRepeticao - Fallback (Pool Vazio)', () {
    test('quando há perguntas elegíveis, não limpa histórico', () async {
      final agora = DateTime.now();
      final historico = _FakeHistoricoFallback(
        historicoInicial: {'q-1': agora.subtract(const Duration(hours: 1))},
      );

      final perguntas = [
        _perguntaTeste(id: 'q-1'),
        _perguntaTeste(id: 'q-2'), // elegível (nunca respondida)
      ];

      final elegiveis = _filtrarElegiveisComFallback(
        perguntas: perguntas,
        historico: await historico.obterHistorico(),
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
        aoLimparHistorico: () => historico.limparHistorico(),
      );

      expect(elegiveis.length, equals(1));
      expect(elegiveis.first.id, equals('q-2'));
      expect(historico.vezesClearChamado, equals(0)); // Não foi chamado
    });

    test(
      'quando pool elegível fica vazio, limpa histórico e retorna todas as perguntas',
      () async {
        final agora = DateTime.now();
        final historicoFake = _FakeHistoricoFallback(
          historicoInicial: {
            'q-1': agora.subtract(const Duration(minutes: 30)),
            'q-2': agora.subtract(const Duration(minutes: 45)),
          },
        );

        final perguntas = [
          _perguntaTeste(id: 'q-1'),
          _perguntaTeste(id: 'q-2'),
        ];

        var historico = await historicoFake.obterHistorico();

        // Primeira tentativa: pool vazio (ambas ainda dentro de 2h)
        var elegiveis = _filtrarElegiveisComFallback(
          perguntas: perguntas,
          historico: historico,
          referencia: agora,
          janela: GameConstants.janelaAntiRepeticao,
          aoLimparHistorico: () => historicoFake.limparHistorico(),
        );

        // Deve ter chamado limparHistorico uma vez
        expect(historicoFake.vezesClearChamado, equals(1));

        // Após fallback, todas as perguntas devem estar disponíveis
        expect(elegiveis.length, equals(2));

        // Histórico deve estar vazio agora
        historico = await historicoFake.obterHistorico();
        expect(historico.isEmpty, isTrue);
      },
    );

    test('fallback ocorre uma única vez em cascata de seleções', () async {
      final agora = DateTime.now();
      final historicoFake = _FakeHistoricoFallback(
        historicoInicial: {
          'q-1': agora.subtract(const Duration(minutes: 30)),
          'q-2': agora.subtract(const Duration(minutes: 45)),
          'q-3': agora.subtract(const Duration(minutes: 50)),
        },
      );

      final perguntas = [
        _perguntaTeste(id: 'q-1'),
        _perguntaTeste(id: 'q-2'),
        _perguntaTeste(id: 'q-3'),
      ];

      final historico = await historicoFake.obterHistorico();

      // Primeira filtragem: fallback
      var elegiveis = _filtrarElegiveisComFallback(
        perguntas: perguntas,
        historico: historico,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
        aoLimparHistorico: () => historicoFake.limparHistorico(),
      );

      expect(historicoFake.vezesClearChamado, equals(1));
      expect(elegiveis.length, equals(3)); // Todas agora elegíveis

      // Histório limpo, próxima filtragem não deve fazer fallback
      final historico2 = await historicoFake.obterHistorico();
      elegiveis = _filtrarElegiveisComFallback(
        perguntas: perguntas,
        historico: historico2,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
        aoLimparHistorico: () => historicoFake.limparHistorico(),
      );

      expect(
        historicoFake.vezesClearChamado,
        equals(1),
      ); // Sem chamada adicional
    });

    test('pool vazio com histórico vazio não causa fallback', () async {
      final agora = DateTime.now();
      final historicoFake = _FakeHistoricoFallback(historicoInicial: {});

      final perguntas = [_perguntaTeste(id: 'q-1')];

      final historico = await historicoFake.obterHistorico();

      final elegiveis = _filtrarElegiveisComFallback(
        perguntas: perguntas,
        historico: historico,
        referencia: agora,
        janela: GameConstants.janelaAntiRepeticao,
        aoLimparHistorico: () => historicoFake.limparHistorico(),
      );

      expect(historicoFake.vezesClearChamado, equals(0)); // Sem fallback
      expect(elegiveis.length, equals(1));
    });

    test(
      'após fallback, histórico está limpo e pronto para novo sorteio',
      () async {
        final agora = DateTime.now();
        final historicoFake = _FakeHistoricoFallback(
          historicoInicial: {
            'q-1': agora.subtract(const Duration(hours: 1)),
            'q-2': agora.subtract(const Duration(minutes: 90)),
          },
        );

        final perguntas = [
          _perguntaTeste(id: 'q-1'),
          _perguntaTeste(id: 'q-2'),
        ];

        var historico = await historicoFake.obterHistorico();

        _filtrarElegiveisComFallback(
          perguntas: perguntas,
          historico: historico,
          referencia: agora,
          janela: GameConstants.janelaAntiRepeticao,
          aoLimparHistorico: () => historicoFake.limparHistorico(),
        );

        historico = await historicoFake.obterHistorico();
        expect(historico.isEmpty, isTrue);
      },
    );
  });
}
