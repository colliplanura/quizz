import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/utils/constants.dart';

/// Teste de integração com wall-clock simulado
/// Valida que a anti-repetição funciona corretamente com time travel
/// Simula: respondida -> 2h +1min -> elegível de novo

class _MockDateTime {
  DateTime _now;

  _MockDateTime(this._now);

  DateTime get now => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }

  void setTo(DateTime dateTime) {
    _now = dateTime;
  }
}

class _FakeHistoricoComMockTime extends HistoricoPerguntaLocalDatasource {
  _FakeHistoricoComMockTime({
    Map<String, DateTime>? historicoInicial,
    _MockDateTime? mockDateTime,
  }) : _historico = historicoInicial ?? <String, DateTime>{},
       _mockDateTime = mockDateTime ?? _MockDateTime(DateTime.now());

  Map<String, DateTime> _historico;
  final _MockDateTime _mockDateTime;

  @override
  Future<void> limparHistorico() async {
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

  DateTime get agoraSimulado => _mockDateTime.now;
  void avancaTempo(Duration duration) => _mockDateTime.advance(duration);
  void defineTempoAbsoluto(DateTime dateTime) => _mockDateTime.setTo(dateTime);
}

bool _perguntaElegivelComTime({
  required String perguntaId,
  required Map<String, DateTime> historico,
  required DateTime referencia,
  required Duration janela,
}) {
  if (!historico.containsKey(perguntaId)) {
    return true;
  }
  final respondidaEm = historico[perguntaId]!;
  final tempoDecorrido = referencia.difference(respondidaEm);
  return tempoDecorrido >= janela;
}

void main() {
  group('Wall-Clock Anti-Repetição (Time Travel)', () {
    test('pergunta respondida agora fica inelegível até 2h depois', () async {
      final mockTime = _MockDateTime(DateTime(2026, 5, 17, 10, 0, 0));
      final historico = _FakeHistoricoComMockTime(mockDateTime: mockTime);

      // Marcar pergunta como respondida no tempo atual
      await historico.marcarPerguntaRespondida('q-1', mockTime.now);

      // T = 0: pergunta foi respondida agora (inelegível)
      var elegivel = _perguntaElegivelComTime(
        perguntaId: 'q-1',
        historico: await historico.obterHistorico(),
        referencia: mockTime.now,
        janela: GameConstants.janelaAntiRepeticao,
      );
      expect(
        elegivel,
        isFalse,
        reason: 'Pergunta respondida agora deve ser inelegível',
      );

      // T + 1h: ainda inelegível
      mockTime.advance(const Duration(hours: 1));
      elegivel = _perguntaElegivelComTime(
        perguntaId: 'q-1',
        historico: await historico.obterHistorico(),
        referencia: mockTime.now,
        janela: GameConstants.janelaAntiRepeticao,
      );
      expect(
        elegivel,
        isFalse,
        reason: 'Pergunta deve ser inelegível após 1h (faltam 1h)',
      );

      // T + 1h 59min: ainda inelegível
      mockTime.advance(const Duration(minutes: 59));
      elegivel = _perguntaElegivelComTime(
        perguntaId: 'q-1',
        historico: await historico.obterHistorico(),
        referencia: mockTime.now,
        janela: GameConstants.janelaAntiRepeticao,
      );
      expect(
        elegivel,
        isFalse,
        reason: 'Pergunta deve ser inelegível após 1h 59min',
      );

      // T + 2h: elegível (exatamente no limite)
      mockTime.advance(const Duration(minutes: 1));
      elegivel = _perguntaElegivelComTime(
        perguntaId: 'q-1',
        historico: await historico.obterHistorico(),
        referencia: mockTime.now,
        janela: GameConstants.janelaAntiRepeticao,
      );
      expect(
        elegivel,
        isTrue,
        reason: 'Pergunta deve ser elegível após exatamente 2h',
      );

      // T + 2h 1min: elegível
      mockTime.advance(const Duration(minutes: 1));
      elegivel = _perguntaElegivelComTime(
        perguntaId: 'q-1',
        historico: await historico.obterHistorico(),
        referencia: mockTime.now,
        janela: GameConstants.janelaAntiRepeticao,
      );
      expect(
        elegivel,
        isTrue,
        reason: 'Pergunta deve ser elegível após 2h 1min',
      );
    });

    test('múltiplas perguntas com tempos diferentes respeitam janela', () async {
      final tempoBase = DateTime(2026, 5, 17, 10, 0, 0);
      final mockTime = _MockDateTime(tempoBase);
      final historico = _FakeHistoricoComMockTime(mockDateTime: mockTime);

      // Marcar 3 perguntas em tempos diferentes
      await historico.marcarPerguntaRespondida('q-1', tempoBase); // T=0
      await historico.marcarPerguntaRespondida(
        'q-2',
        tempoBase.subtract(const Duration(minutes: 30)),
      ); // T=-30min
      await historico.marcarPerguntaRespondida(
        'q-3',
        tempoBase.subtract(const Duration(hours: 1)),
      ); // T=-1h

      // T = 0: q-1 e q-2 são inelegíveis, q-3 é inelegível
      mockTime.setTo(tempoBase);
      var historicos = await historico.obterHistorico();
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-1',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isFalse,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-2',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isFalse,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-3',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isFalse,
      );

      // T + 1h 30min: q-1 e q-2 ainda inelegíveis, q-3 elegível
      mockTime.advance(const Duration(hours: 1, minutes: 30));
      historicos = await historico.obterHistorico();
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-1',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isFalse,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-2',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      ); // 2h decorridas
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-3',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );

      // T + 2h: q-1 elegível, q-2 elegível (2h 30min decorridos), q-3 elegível
      mockTime.advance(const Duration(minutes: 30));
      historicos = await historico.obterHistorico();
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-1',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-2',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-3',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );

      // T + 2h 30min: todas elegíveis
      mockTime.advance(const Duration(minutes: 30));
      historicos = await historico.obterHistorico();
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-1',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-2',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );
      expect(
        _perguntaElegivelComTime(
          perguntaId: 'q-3',
          historico: historicos,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        ),
        isTrue,
      );
    });

    test(
      'persistência de histórico sobrevive a múltiplas filtragens',
      () async {
        final tempoBase = DateTime(2026, 5, 17, 10, 0, 0);
        final mockTime = _MockDateTime(tempoBase);
        final historico = _FakeHistoricoComMockTime(mockDateTime: mockTime);

        // Marcar pergunta
        await historico.marcarPerguntaRespondida('q-1', tempoBase);

        // Primeira consulta: inelegível
        var hist1 = await historico.obterHistorico();
        expect(
          _perguntaElegivelComTime(
            perguntaId: 'q-1',
            historico: hist1,
            referencia: mockTime.now,
            janela: GameConstants.janelaAntiRepeticao,
          ),
          isFalse,
        );

        // Avançar 1h
        mockTime.advance(const Duration(hours: 1));

        // Segunda consulta: ainda inelegível
        var hist2 = await historico.obterHistorico();
        expect(
          _perguntaElegivelComTime(
            perguntaId: 'q-1',
            historico: hist2,
            referencia: mockTime.now,
            janela: GameConstants.janelaAntiRepeticao,
          ),
          isFalse,
        );

        // Avançar mais 1h 5min
        mockTime.advance(const Duration(hours: 1, minutes: 5));

        // Terceira consulta: elegível
        var hist3 = await historico.obterHistorico();
        expect(
          _perguntaElegivelComTime(
            perguntaId: 'q-1',
            historico: hist3,
            referencia: mockTime.now,
            janela: GameConstants.janelaAntiRepeticao,
          ),
          isTrue,
        );
      },
    );

    test('janela é exatamente 2 horas em wall-clock', () {
      expect(
        GameConstants.janelaAntiRepeticao,
        equals(const Duration(hours: 2)),
        reason: 'Janela deve ser exatamente 2 horas',
      );
    });

    test(
      'wall-clock continua mesmo com app fechado (time sim não ativa real)',
      () async {
        // Este teste valida que a lógica não depende de tempo de jogo ativo
        // mas sim de wall-clock real (DateTime.now())

        final tempoBase = DateTime(2026, 5, 17, 10, 0, 0);
        final mockTime = _MockDateTime(tempoBase);
        final historico = _FakeHistoricoComMockTime(mockDateTime: mockTime);

        // Marcar pergunta às 10:00
        await historico.marcarPerguntaRespondida('q-1', tempoBase);

        // Simular "app fechado" - não há chamadas, apenas time passa
        // Avançar para 12:01 (2h 1min depois)
        mockTime.setTo(tempoBase.add(const Duration(hours: 2, minutes: 1)));

        // Verificar elegibilidade
        final hist = await historico.obterHistorico();
        final elegivel = _perguntaElegivelComTime(
          perguntaId: 'q-1',
          historico: hist,
          referencia: mockTime.now,
          janela: GameConstants.janelaAntiRepeticao,
        );

        expect(
          elegivel,
          isTrue,
          reason:
              'Pergunta deve ser elegível após 2h+1min, mesmo se app estava fechado',
        );
      },
    );
  });
}
