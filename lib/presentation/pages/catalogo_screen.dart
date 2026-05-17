import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/catalogo_bloc.dart';
import '../bloc/catalogo_event.dart';
import '../bloc/catalogo_state.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  @override
  void initState() {
    super.initState();
    // Load catalog on initialization
    context.read<CatalogoBLoC>().add(const CarregarCatalogoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Perguntas'),
        actions: [
          BlocBuilder<CatalogoBLoC, CatalogoState>(
            builder: (context, state) {
              if (state is CatalogoCarregado) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: Text('${state.total} perguntas')),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CatalogoBLoC, CatalogoState>(
        builder: (context, state) {
          if (state is CatalogoCarregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CatalogoErro) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar catálogo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(state.mensagem),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CatalogoBLoC>().add(
                        const CarregarCatalogoEvent(),
                      );
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (state is CatalogoCarregado) {
            return _buildCatalogoUI(context, state);
          }

          if (state is CatalogoValidado) {
            return _buildValidacaoUI(context, state);
          }

          return const Center(child: Text('Estado desconhecido'));
        },
      ),
    );
  }

  Widget _buildCatalogoUI(BuildContext context, CatalogoCarregado state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estatísticas principais
            _buildEstatisticasCard(context, state),
            const SizedBox(height: 24),

            // Botões de ação
            _buildAcoesCard(context),
            const SizedBox(height: 24),

            // Perguntas por dificuldade
            _buildDificuldadeSection(context, state),
            const SizedBox(height: 24),

            // Perguntas por categoria
            _buildCategoriaSection(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildEstatisticasCard(BuildContext context, CatalogoCarregado state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estatísticas', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Total de\nPerguntas', '${state.total}'),
                _buildStatColumn(
                  'Categorias',
                  '${state.distribuicaoCategoria.length}',
                ),
                _buildStatColumn(
                  'Níveis de\nDificuldade',
                  '${state.distribuicaoDificuldade.length}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAcoesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ações', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CatalogoBLoC>().add(
                    const ValidarCatalogoEvent(),
                  );
                },
                child: const Text('Validar Catálogo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDificuldadeSection(
    BuildContext context,
    CatalogoCarregado state,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição por Dificuldade',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...List.generate(10, (index) {
              final nivel = index + 1;
              final total = state.distribuicaoDificuldade[nivel] ?? 0;
              final percentual = (total / state.total * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('Nível $nivel')),
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total / state.total,
                          minHeight: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$total ($percentual%)'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaSection(BuildContext context, CatalogoCarregado state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição por Categoria',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...state.distribuicaoCategoria.entries.map((entry) {
              final categoria = entry.key;
              final total = entry.value;
              final percentual = (total / state.total * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text(categoria)),
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total / state.total,
                          minHeight: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$total ($percentual%)'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildValidacaoUI(BuildContext context, CatalogoValidado state) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Colors.green.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Catálogo Validado!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(state.validacao.mensagem),
              const SizedBox(height: 24),
              if (state.validacao.totalPerguntas != null)
                Text('Total de perguntas: ${state.validacao.totalPerguntas}'),
              if (state.validacao.totalCategorias != null)
                Text('Categorias: ${state.validacao.totalCategorias}'),
              if (state.validacao.totalDificuldades != null)
                Text(
                  'Níveis de dificuldade: ${state.validacao.totalDificuldades}',
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<CatalogoBLoC>().add(
                    const CarregarCatalogoEvent(),
                  );
                },
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
