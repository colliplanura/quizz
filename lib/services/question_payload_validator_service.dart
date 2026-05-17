import '../data/models/pergunta_model.dart';
import 'logging_service.dart';

class QuestionPayloadValidatorService {
  QuestionPayloadValidatorService._();

  static List<PerguntaModel> validar(List<dynamic> payload) {
    final validas = <PerguntaModel>[];

    for (var i = 0; i < payload.length; i++) {
      try {
        if (payload[i] is! Map<String, dynamic>) {
          LoggingService.warning(
            'Item $i ignorado: não é objeto JSON',
            contexto: 'QuestionPayloadValidator',
          );
          continue;
        }
        final model = PerguntaModel.fromJson(payload[i] as Map<String, dynamic>);
        if (_perguntaValida(model)) {
          validas.add(model);
        } else {
          LoggingService.warning(
            'Item $i ignorado: campos inválidos (id=${model.id})',
            contexto: 'QuestionPayloadValidator',
          );
        }
      } catch (e) {
        LoggingService.warning(
          'Item $i ignorado: parse falhou ($e)',
          contexto: 'QuestionPayloadValidator',
        );
      }
    }

    LoggingService.info(
      '${validas.length}/${payload.length} perguntas válidas',
      contexto: 'QuestionPayloadValidator',
    );
    return validas;
  }

  static bool _perguntaValida(PerguntaModel p) {
    return p.id.isNotEmpty &&
        p.pergunta.isNotEmpty &&
        p.resposta.isNotEmpty &&
        p.exibicaoResposta.isNotEmpty &&
        p.dificuldade >= 1 &&
        p.dificuldade <= 10;
  }
}
