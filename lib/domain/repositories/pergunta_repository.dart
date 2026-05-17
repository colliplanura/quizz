import '../entities/pergunta.dart';

abstract class PerguntaRepository {
  Future<List<Pergunta>> obterTodasPerguntas();
  Future<Pergunta?> obterPerguntaPorId(String id);
  Future<List<Pergunta>> obterPerguntasPorDificuldade(int dificuldade);
  Future<void> salvarPerguntas(List<Pergunta> perguntas);
  Future<void> carregarPacoteEmbarcado();
  Future<bool> temPerguntas();
}
