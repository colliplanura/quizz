import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../models/pergunta_model.dart';

class GithubRemoteSource {
  GithubRemoteSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<PerguntaModel>> obterPerguntas() async {
    final uri = Uri.parse(GameConstants.urlPerguntasGithub);
    // Segurança: garantir somente HTTPS
    if (uri.scheme != 'https') {
      throw const SocketException('Somente HTTPS é permitido para sync');
    }

    final response = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(_timeout);

    if (response.statusCode == 304) return [];
    if (response.statusCode != 200) {
      throw HttpException(
        'GitHub respondeu com status ${response.statusCode}',
        uri: uri,
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! List) throw const FormatException('Payload não é uma lista JSON');

    return json
        .cast<Map<String, dynamic>>()
        .map(PerguntaModel.fromJson)
        .toList();
  }
}
