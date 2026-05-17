import '../entities/progresso.dart';
import '../entities/partida.dart';
import '../entities/trofeu.dart';

abstract class ProgressoRepository {
  Future<Progresso?> obterProgresso();
  Future<void> salvarProgresso(Progresso progresso);
  Future<Partida?> obterPartidaAtiva();
  Future<void> salvarPartida(Partida partida);
  Future<void> limparPartidaAtiva();
  Future<List<Trofeu>> obterTrofeus();
  Future<void> salvarTrofeu(Trofeu trofeu);
}
