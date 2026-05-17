import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/pergunta_catalogo_model.dart';
import '../../../domain/entities/pergunta_catalogo.dart';
import '../../../utils/constants.dart';

/// DataSource for loading catalog from assets
class AssetCatalogoLocalDataSource {
  /// Load all questions from assets/data/perguntas_inicial.json
  Future<List<PerguntaCatalogo>> obterCatalogoPrincipal() async {
    try {
      final json = await rootBundle.loadString(
        GameConstants.pathPerguntasEmbarcadas,
      );
      final lista = (jsonDecode(json) as List)
          .cast<Map<String, dynamic>>()
          .map(PerguntaCatalogoModel.fromJson)
          .toList();
      return lista.cast<PerguntaCatalogo>();
    } catch (e) {
      throw Exception('Erro ao carregar catálogo inicial: $e');
    }
  }

  /// Load and validate catalog
  Future<List<PerguntaCatalogo>> obterCatalogoValidado() async {
    final catalogo = await obterCatalogoPrincipal();
    _validarCatalogo(catalogo);
    return catalogo;
  }

  /// Validate catalog structure and content
  void _validarCatalogo(List<PerguntaCatalogo> catalogo) {
    if (catalogo.isEmpty) {
      throw Exception('Catálogo está vazio');
    }

    if (catalogo.length != 1000) {
      throw Exception(
        'Catálogo deve conter 1000 perguntas, encontradas ${catalogo.length}',
      );
    }

    // Check for unique IDs
    final ids = <String>{};
    for (final pergunta in catalogo) {
      if (ids.contains(pergunta.id)) {
        throw Exception('IDs duplicados: ${pergunta.id}');
      }
      ids.add(pergunta.id);
    }

    // Check difficulty range
    for (final pergunta in catalogo) {
      if (pergunta.dificuldade < 1 || pergunta.dificuldade > 10) {
        throw Exception(
          'Dificuldade inválida para ${pergunta.id}: ${pergunta.dificuldade}',
        );
      }
    }

    // Check minimum categories
    final categorias = <String>{};
    for (final pergunta in catalogo) {
      categorias.add(pergunta.categoria);
    }

    if (categorias.length < 10) {
      throw Exception(
        'Catálogo deve ter no mínimo 10 categorias, encontradas ${categorias.length}',
      );
    }

    // Check minimum per category
    final contagemPorCategoria = <String, int>{};
    for (final pergunta in catalogo) {
      contagemPorCategoria[pergunta.categoria] =
          (contagemPorCategoria[pergunta.categoria] ?? 0) + 1;
    }

    for (final entry in contagemPorCategoria.entries) {
      if (entry.value < 50) {
        throw Exception(
          'Categoria "${entry.key}" deve ter no mínimo 50 perguntas, encontradas ${entry.value}',
        );
      }
    }
  }

  /// Get difficulty distribution statistics
  Future<Map<int, int>> obterDistribuicaoDificuldade() async {
    final catalogo = await obterCatalogoPrincipal();
    final distribuicao = <int, int>{};

    for (final pergunta in catalogo) {
      distribuicao[pergunta.dificuldade] =
          (distribuicao[pergunta.dificuldade] ?? 0) + 1;
    }

    return distribuicao;
  }

  /// Get category distribution statistics
  Future<Map<String, int>> obterDistribuicaoCategoria() async {
    final catalogo = await obterCatalogoPrincipal();
    final distribuicao = <String, int>{};

    for (final pergunta in catalogo) {
      distribuicao[pergunta.categoria] =
          (distribuicao[pergunta.categoria] ?? 0) + 1;
    }

    return distribuicao;
  }

  /// Get count of questions
  Future<int> obterTotal() async {
    final catalogo = await obterCatalogoPrincipal();
    return catalogo.length;
  }
}
