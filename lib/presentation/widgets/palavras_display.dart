import 'package:flutter/material.dart';
import '../../utils/validators.dart';

class PalavrasDisplay extends StatelessWidget {
  const PalavrasDisplay({
    super.key,
    required this.resposta,
    required this.exibicaoResposta,
    required this.letrasAdivinhadas,
  });

  final String resposta;
  final String exibicaoResposta;
  final List<String> letrasAdivinhadas;

  @override
  Widget build(BuildContext context) {
    final letrasExibicao = exibicaoResposta.split('');
    final letrasResposta = resposta.split('');

    return Wrap(
      spacing: 4,
      children: List.generate(letrasExibicao.length, (i) {
        if (letrasExibicao[i] == ' ') {
          return const SizedBox(width: 16);
        }
        final letraNorm = Validators.normalizarResposta(letrasResposta[i]);
        final revelada = letrasAdivinhadas.contains(letraNorm);
        return _LetraCard(
          letra: revelada ? letrasExibicao[i].toUpperCase() : '_',
          revelada: revelada,
        );
      }),
    );
  }
}

class _LetraCard extends StatelessWidget {
  const _LetraCard({required this.letra, required this.revelada});

  final String letra;
  final bool revelada;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: revelada
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
      ),
      child: Text(
        letra,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: revelada
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
