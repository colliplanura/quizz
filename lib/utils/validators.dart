class Validators {
  Validators._();

  static String normalizarResposta(String resposta) {
    var normalizado = resposta.toLowerCase().trim();
    const acentos = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'õ': 'o',
      'ô': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
    };
    for (final entry in acentos.entries) {
      normalizado = normalizado.replaceAll(entry.key, entry.value);
    }
    return normalizado;
  }

  static String obterContexto(Map<String, String> contexto, String idioma) {
    return contexto[idioma] ?? contexto['pt_BR'] ?? '';
  }

  static bool respostaCorreta(String tentativa, String respostaNormalizada) {
    return normalizarResposta(tentativa) == respostaNormalizada;
  }

  static bool letraValida(String letra) {
    if (letra.length != 1) return false;
    return RegExp(
      r'^[a-záàãâäéèêëíìîïóòõôöúùûüçñA-ZÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇÑ0-9]$',
    ).hasMatch(letra);
  }
}
