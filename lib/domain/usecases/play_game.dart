import '../entities/partida.dart';
import '../entities/pergunta.dart';
import '../entities/progresso.dart';
import '../repositories/pergunta_repository.dart';
import '../repositories/progresso_repository.dart';
import '../../data/models/partida_model.dart';
import '../../data/models/progresso_model.dart';

class PlayGame {
  PlayGame({
    required this.perguntaRepository,
    required this.progressoRepository,
  });

  final PerguntaRepository perguntaRepository;
  final ProgressoRepository progressoRepository;

  Future<({Partida partida, Progresso progresso, Pergunta pergunta})> executar() async {
    // Garantir que há perguntas
    if (!await perguntaRepository.temPerguntas()) {
      await perguntaRepository.carregarPacoteEmbarcado();
    }

    // Carregar ou criar progresso
    var progresso = await progressoRepository.obterProgresso() ??
        ProgressoModel.inicial();

    // Verificar partida ativa
    final partidaExistente = await progressoRepository.obterPartidaAtiva();
    if (partidaExistente != null &&
        partidaExistente.estado == EstadoPartida.emAndamento) {
      final pergunta = await perguntaRepository
          .obterPerguntaPorId(partidaExistente.perguntaAtualId);
      if (pergunta != null) {
        return (partida: partidaExistente, progresso: progresso, pergunta: pergunta);
      }
    }

    // Iniciar nova partida
    final perguntas = await perguntaRepository.obterTodasPerguntas();
    final pergunta = _selecionarPergunta(perguntas, progresso);
    final novaPartida = PartidaModel.nova(
      nivel: progresso.nivelAtual,
      perguntaAtualId: pergunta.id,
    );

    await progressoRepository.salvarPartida(novaPartida);
    await progressoRepository.salvarProgresso(
      progresso.copyWith(partidaAtivaId: novaPartida.id),
    );

    return (partida: novaPartida, progresso: progresso, pergunta: pergunta);
  }

  Future<({Partida partida, Progresso progresso, Pergunta pergunta})> proximaRodada({
    required Progresso progresso,
    required int nivel,
  }) async {
    final perguntas = await perguntaRepository.obterTodasPerguntas();
    final pergunta = _selecionarPergunta(perguntas, progresso);
    final novaPartida = PartidaModel.nova(
      nivel: nivel,
      perguntaAtualId: pergunta.id,
    );
    await progressoRepository.salvarPartida(novaPartida);
    await progressoRepository.salvarProgresso(
      progresso.copyWith(partidaAtivaId: novaPartida.id),
    );
    return (partida: novaPartida, progresso: progresso, pergunta: pergunta);
  }

  Pergunta _selecionarPergunta(List<Pergunta> perguntas, Progresso progresso) {
    if (perguntas.isEmpty) throw StateError('Sem perguntas disponíveis');
    final nivel = progresso.nivelAtual;
    // Selecionar baseado em dificuldade proporcional ao nível
    final dificuldadeAlvo = ((nivel - 1) % 10) + 1;
    final candidatas = perguntas
        .where((p) => p.dificuldade == dificuldadeAlvo)
        .toList();
    if (candidatas.isEmpty) return perguntas[nivel % perguntas.length];
    return candidatas[nivel % candidatas.length];
  }
}
