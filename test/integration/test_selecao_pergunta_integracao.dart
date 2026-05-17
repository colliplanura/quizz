import 'package:flutter_test/flutter_test.dart';

import 'package:quizverse_forca/data/datasources/local/historico_pergunta_local_datasource.dart';
import 'package:quizverse_forca/domain/entities/pergunta.dart';
import 'package:quizverse_forca/domain/usecases/selecionar_pergunta.dart';
import 'package:quizverse_forca/domain/usecases/calculador_distribuicao.dart';

class _FakeHistoricoPerguntaLocalDatasource
    extends HistoricoPerguntaLocalDatasource {
  final Map<String, DateTime> _historico = {};
  int limparHistoricoChamadas = 0;

  @override
  Future<Map<String, DateTime>> obterHistorico() async =>
      Map<String, DateTime>.from(_historico);

  @override
  Future<void> marcarPerguntaRespondida(
    String perguntaId,
    DateTime quando,
  ) async {
    _historico[perguntaId] = quando;
  }

  @override
  Future<void> limparHistorico() async {
    limparHistoricoChamadas += 1;
    _historico.clear();
  }

  Future<void> seedHistorico(Map<String, DateTime> historico) async {
    _historico
      ..clear()
      ..addAll(historico);
  }
}

List<Pergunta> _criarBasePerguntasVariada() {
  final perguntas = <Pergunta>[];
  for (int dif = 1; dif <= 10; dif++) {
    for (int i = 0; i < 30; i++) {
      perguntas.add(
        Pergunta(
          id: 'pergunta-$dif-$i',
          pergunta: 'Pergunta $dif-$i',
          resposta: 'resposta',
          exibicaoResposta: 'Resposta',
          categoria: 'categoria-$dif',
          dificuldade: dif,
          contextoHistorico: {'pt_BR': 'Contexto $dif'},
        ),
      );
    }
  }
  return perguntas;
}

void main() {
  late _FakeHistoricoPerguntaLocalDatasource mockHistoricoDatasource;
  late SelecionarPergunta selecionarPergunta;
  late CalculadorDistribuicao calculadorDistribuicao;

  setUp(() {
    mockHistoricoDatasource = _FakeHistoricoPerguntaLocalDatasource();
    selecionarPergunta = SelecionarPergunta(
      historicoDatasource: mockHistoricoDatasource,
    );
    calculadorDistribuicao = CalculadorDistribuicao();
  });

  group('Integração: Seleção de Pergunta com Distribuição', () {
    test('Fluxo completo: seleção com histórico vazio', () async {
      // Setup: Criar base de perguntas variada
      final perguntas = _criarBasePerguntasVariada();

      // Execute: Selecionar pergunta em nível 1
      final pergunta1 = await selecionarPergunta.executar(
        perguntas: perguntas,
        nivel: 1,
      );

      // Verify: Pergunta deve ter dificuldade apropriada
      expect(pergunta1.dificuldade, lessThanOrEqualTo(10));
      expect(pergunta1.dificuldade, greaterThanOrEqualTo(1));

      // Verify: Deve ter sido marcada como respondida
      final historico = await mockHistoricoDatasource.obterHistorico();
      expect(historico.containsKey(pergunta1.id), true);
    });

    test('Fluxo com anti-repetição: pergunta recente não é sorteada', () async {
      // Setup: Criar base de perguntas
      final perguntas = _criarBasePerguntasVariada();

      // Mock histórico com pergunta respondida há 30 minutos
      final historico = <String, DateTime>{
        'pergunta-1-0': DateTime.now().subtract(const Duration(minutes: 30)),
      };

      await mockHistoricoDatasource.seedHistorico(historico);

      // Execute: 50 sorteios
      final selecionadas = <String>{};
      for (int i = 0; i < 50; i++) {
        final pergunta = await selecionarPergunta.executar(
          perguntas: perguntas,
          nivel: 1,
        );
        selecionadas.add(pergunta.id);
      }

      // Verify: pergunta-1-0 não deve aparecer frequentemente
      expect(
        selecionadas.contains('pergunta-1-0'),
        false,
        reason: 'Pergunta respondida recentemente não deveria ser sorteada',
      );
    });

    test('Fluxo de fallback: pool vazio limpa histórico', () async {
      // Setup: Apenas 1 pergunta para forçar pool vazio
      final umapergunta = [
        Pergunta(
          id: 'pergunta-unica',
          pergunta: 'Pergunta única',
          resposta: 'resposta',
          exibicaoResposta: 'Resposta',
          categoria: 'categoria',
          dificuldade: 5,
          contextoHistorico: {'pt_BR': 'Contexto'},
        ),
      ];

      // Mock histórico com a pergunta respondida há 30 minutos
      final historico = <String, DateTime>{
        'pergunta-unica': DateTime.now().subtract(const Duration(minutes: 30)),
      };

      await mockHistoricoDatasource.seedHistorico(historico);

      // Execute: Selecionar pergunta (deve triggerr fallback e limpar histórico)
      final pergunta = await selecionarPergunta.executar(
        perguntas: umapergunta,
        nivel: 1,
      );

      // Verify: Fallback foi acionado
      expect(mockHistoricoDatasource.limparHistoricoChamadas, equals(1));
      expect(pergunta.id, equals('pergunta-unica'));
    });

    test('Fluxo de múltiplos níveis mantém distribuição apropriada', () async {
      // Setup: Base de perguntas
      final perguntas = _criarBasePerguntasVariada();

      // Execute: Selecionar 10 perguntas em níveis progressivos
      final distribuicaoPorNivel = <int, List<int>>{};

      for (int nivel = 1; nivel <= 10; nivel++) {
        distribuicaoPorNivel[nivel] = [];
        for (int i = 0; i < 10; i++) {
          final pergunta = await selecionarPergunta.executar(
            perguntas: perguntas,
            nivel: nivel,
          );
          distribuicaoPorNivel[nivel]!.add(pergunta.dificuldade);
        }
      }

      // Verify: Distribuição por nível
      final dificuldadesNivel1 = distribuicaoPorNivel[1]!;
      final dificuldadesNivel10 = distribuicaoPorNivel[10]!;

      // Nível 1 deve ter predominância de baixas dificuldades
      final baixasNivel1 = dificuldadesNivel1.where((d) => d <= 3).length;
      expect(baixasNivel1, greaterThanOrEqualTo(5));

      // Nível 10 deve ter predominância de altas dificuldades
      final altasNivel10 = dificuldadesNivel10.where((d) => d >= 8).length;
      expect(altasNivel10, greaterThanOrEqualTo(5));
    });

    test('Calculador de distribuição valida perfis', () {
      // Execute: Obter perfil para diferentes níveis
      final perfilNivel1 = calculadorDistribuicao.obterPerfilParaNivel(1);
      final perfilNivel5 = calculadorDistribuicao.obterPerfilParaNivel(5);
      final perfilNivel10 = calculadorDistribuicao.obterPerfilParaNivel(10);

      // Verify: Todos os perfis devem ser válidos
      expect(
        calculadorDistribuicao.validarPerfil(perfilNivel1),
        true,
        reason: 'Perfil nível 1 deve ser válido',
      );
      expect(
        calculadorDistribuicao.validarPerfil(perfilNivel5),
        true,
        reason: 'Perfil nível 5 deve ser válido',
      );
      expect(
        calculadorDistribuicao.validarPerfil(perfilNivel10),
        true,
        reason: 'Perfil nível 10 deve ser válido',
      );

      // Verify: Pesos devem ser distribuídos corretamente
      expect(
        perfilNivel1.pesosPorDificuldade.length,
        equals(10),
        reason: 'Perfil deve ter pesos para 10 dificuldades',
      );
    });

    test('Integração com análise de probabilidades', () {
      // Execute: Obter probabilidades para cada nível
      final probNivel1 = calculadorDistribuicao.obterProbabilidadesParaNivel(1);
      final probNivel5 = calculadorDistribuicao.obterProbabilidadesParaNivel(5);
      final probNivel10 = calculadorDistribuicao.obterProbabilidadesParaNivel(
        10,
      );

      // Verify: Nível 1 - dificuldades baixas devem ter maior probabilidade
      final probBaixasNivel1 =
          (probNivel1[1] ?? 0) + (probNivel1[2] ?? 0) + (probNivel1[3] ?? 0);
      expect(probBaixasNivel1, greaterThan(0.6));

      // Verify: Nível 10 - dificuldades altas devem ter maior probabilidade
      final probAltasNivel10 =
          (probNivel10[8] ?? 0) +
          (probNivel10[9] ?? 0) +
          (probNivel10[10] ?? 0);
      expect(probAltasNivel10, greaterThan(0.6));

      // Verify: Nível 5 - probabilidades distribuídas ao redor do nível
      final probProximasNivel5 =
          (probNivel5[4] ?? 0) + (probNivel5[5] ?? 0) + (probNivel5[6] ?? 0);
      expect(probProximasNivel5, greaterThan(0.4));
    });
  });
}
