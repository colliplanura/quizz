import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';

class _FakeHistoricoDatasource extends HistoricoPerguntaLocalDatasource {
  _FakeHistoricoDatasource({Map<String, DateTime>? historicoInicial})
    : _historico = historicoInicial ?? <String, DateTime>{};

  Map<String, DateTime> _historico;

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
}

class _FakeHistoricoSemPersistencia extends HistoricoPerguntaLocalDatasource {
  @override
  Future<void> limparHistorico() async {}

  @override
  Future<void> marcarPerguntaRespondida(
    String perguntaId,
    DateTime quando,
  ) async {}

  @override
  Future<Map<String, DateTime>> obterHistorico() async => <String, DateTime>{};

  @override
  Future<void> salvarHistorico(Map<String, DateTime> historico) async {}
}

Pergunta _pergunta(int dificuldade, {String? id}) {
  return Pergunta(
    id: id ?? 'q-$dificuldade',
    pergunta: 'Pergunta $dificuldade',
    resposta: 'resposta$dificuldade',
    exibicaoResposta: 'Resposta $dificuldade',
    categoria: 'geral',
    dificuldade: dificuldade,
    contextoHistorico: const {'pt_BR': 'Contexto'},
    dataCriacao: DateTime(2026, 5, 17),
  );
}

void main() {
  group('SelecionarPergunta', () {
    test('evita repetir pergunta dentro da janela de 2 horas', () async {
      final agora = DateTime.now();
      final historico = _FakeHistoricoDatasource(
        historicoInicial: {'q-1': agora.subtract(const Duration(minutes: 30))},
      );
      final useCase = SelecionarPergunta(
        historicoDatasource: historico,
        random: Random(1),
      );

      final resultado = await useCase.executar(
        perguntas: [
          _pergunta(1, id: 'q-1'),
          _pergunta(1, id: 'q-2'),
        ],
        nivel: 1,
      );

      expect(resultado.id, equals('q-2'));
    });

    test(
      'limpa histórico quando pool elegível esgota e continua sorteio',
      () async {
        final agora = DateTime.now();
        final historico = _FakeHistoricoDatasource(
          historicoInicial: {
            'q-1': agora.subtract(const Duration(minutes: 10)),
            'q-2': agora.subtract(const Duration(minutes: 20)),
          },
        );
        final useCase = SelecionarPergunta(
          historicoDatasource: historico,
          random: Random(7),
        );

        final resultado = await useCase.executar(
          perguntas: [
            _pergunta(1, id: 'q-1'),
            _pergunta(10, id: 'q-2'),
          ],
          nivel: 1,
        );

        final historicoFinal = await historico.obterHistorico();
        expect(['q-1', 'q-2'], contains(resultado.id));
        expect(historicoFinal.length, equals(1));
        expect(historicoFinal.containsKey(resultado.id), isTrue);
      },
    );

    test('níveis iniciais favorecem dificuldades 1-3', () async {
      final useCase = SelecionarPergunta(
        historicoDatasource: _FakeHistoricoSemPersistencia(),
        random: Random(42),
      );
      final perguntas = List.generate(10, (i) => _pergunta(i + 1));

      var totalBaixas = 0;
      const totalSorteios = 4000;
      for (var i = 0; i < totalSorteios; i++) {
        final p = await useCase.executar(perguntas: perguntas, nivel: 1);
        if (p.dificuldade >= 1 && p.dificuldade <= 3) {
          totalBaixas++;
        }
      }

      final proporcao = totalBaixas / totalSorteios;
      expect(proporcao, greaterThanOrEqualTo(0.70));
    });

    test('níveis avançados favorecem dificuldades 8-10', () async {
      final useCase = SelecionarPergunta(
        historicoDatasource: _FakeHistoricoSemPersistencia(),
        random: Random(123),
      );
      final perguntas = List.generate(10, (i) => _pergunta(i + 1));

      var totalAltas = 0;
      const totalSorteios = 4000;
      for (var i = 0; i < totalSorteios; i++) {
        final p = await useCase.executar(perguntas: perguntas, nivel: 10);
        if (p.dificuldade >= 8 && p.dificuldade <= 10) {
          totalAltas++;
        }
      }

      final proporcao = totalAltas / totalSorteios;
      expect(proporcao, greaterThanOrEqualTo(0.70));
    });
  });
}
