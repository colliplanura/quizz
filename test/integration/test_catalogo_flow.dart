import 'package:flutter_test/flutter_test.dart';
import 'package:quizverse_forca/data/datasources/local/asset_catalogo_local_datasource.dart';
import 'package:quizverse_forca/data/repositories/catalogo_repository_impl.dart';
import 'package:quizverse_forca/domain/usecases/listar_catalogo.dart';
import 'package:quizverse_forca/domain/usecases/validar_catalogo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Catalogo Integration Tests', () {
    late AssetCatalogoLocalDataSource assetDataSource;
    late CatalogoRepositoryImpl repository;
    late ListarCatalogoUseCase listarCatalogo;
    late ValidarCatalogoUseCase validarCatalogo;

    setUpAll(() {
      assetDataSource = AssetCatalogoLocalDataSource();
      repository = CatalogoRepositoryImpl(assetDataSource);
      listarCatalogo = ListarCatalogoUseCase(repository);
      validarCatalogo = ValidarCatalogoUseCase(repository);
    });

    test('fluxo completo de carregamento e validação do catálogo', () async {
      // Arrange
      expect(assetDataSource, isNotNull);
      expect(repository, isNotNull);

      // Act
      final perguntas = await listarCatalogo();
      final validacao = await validarCatalogo();

      // Assert
      expect(perguntas, isNotEmpty);
      expect(perguntas.length, equals(1000));
      expect(validacao.valido, isTrue);
      expect(validacao.totalPerguntas, equals(1000));
      expect(validacao.totalCategorias, greaterThanOrEqualTo(10));
      expect(validacao.totalDificuldades, equals(10));
    });

    test('deve obter perguntas por dificuldade', () async {
      // Act
      final faceis = await listarCatalogo.obterPorDificuldade(1);
      final medio = await listarCatalogo.obterPorDificuldade(5);
      final dificil = await listarCatalogo.obterPorDificuldade(10);

      // Assert
      expect(faceis, isNotEmpty);
      expect(medio, isNotEmpty);
      expect(dificil, isNotEmpty);
      expect(faceis.every((p) => p.dificuldade == 1), isTrue);
      expect(medio.every((p) => p.dificuldade == 5), isTrue);
      expect(dificil.every((p) => p.dificuldade == 10), isTrue);
    });

    test('deve obter perguntas por categoria', () async {
      // Act
      final distribuicao = await listarCatalogo.obterDistribuicaoCategoria();
      expect(distribuicao.isNotEmpty, isTrue);

      // Get first category and fetch questions
      for (final categoria in distribuicao.keys) {
        final perguntas = await listarCatalogo.obterPorCategoria(categoria);

        // Assert
        expect(perguntas, isNotEmpty);
        expect(perguntas.every((p) => p.categoria == categoria), isTrue);
        expect(perguntas.length, greaterThanOrEqualTo(50));
      }
    });

    test('deve retornar distribuição correta de dificuldade', () async {
      // Act
      final distribuicao = await listarCatalogo.obterDistribuicaoDificuldade();

      // Assert
      expect(distribuicao.length, equals(10));
      var total = 0;
      for (var count in distribuicao.values) {
        total += count;
        expect(count, greaterThan(0));
      }
      expect(total, equals(1000));
    });

    test('deve retornar distribuição correta de categoria', () async {
      // Act
      final distribuicao = await listarCatalogo.obterDistribuicaoCategoria();

      // Assert
      expect(distribuicao.length, greaterThanOrEqualTo(10));
      var total = 0;
      for (final entry in distribuicao.entries) {
        expect(entry.value, greaterThanOrEqualTo(50));
        total += entry.value;
      }
      expect(total, equals(1000));
    });

    test('validação deve detectar integridade do catálogo', () async {
      // Act
      final validacao = await validarCatalogo();

      // Assert
      expect(validacao.valido, isTrue);
      expect(validacao.mensagem.isNotEmpty, isTrue);
      expect(validacao.totalPerguntas, equals(1000));
      expect(validacao.totalCategorias, greaterThanOrEqualTo(10));
      expect(validacao.totalDificuldades, equals(10));
      expect(validacao.distribuicaoDificuldade, isNotNull);
      expect(validacao.distribuicaoCategoria, isNotNull);
    });

    test('deve obter pergunta específica por ID', () async {
      // Arrange
      final todas = await listarCatalogo();
      expect(todas, isNotEmpty);
      final primeiraPergunta = todas.first;

      // Act
      final pergunta = await repository.obterPorId(primeiraPergunta.id);

      // Assert
      expect(pergunta, isNotNull);
      expect(pergunta!.id, equals(primeiraPergunta.id));
      expect(pergunta.enunciado, isNotEmpty);
      expect(pergunta.respostaNormalizada, isNotEmpty);
      expect(pergunta.categoria, isNotEmpty);
    });

    test('total deve ser consistente entre métodos', () async {
      // Act
      final perguntas = await listarCatalogo();
      final total = await repository.obterTotal();
      final distribuicao = await listarCatalogo.obterDistribuicaoDificuldade();

      // Assert
      expect(total, equals(perguntas.length));
      expect(total, equals(1000));

      var somaDistribuicao = 0;
      for (var count in distribuicao.values) {
        somaDistribuicao += count;
      }
      expect(somaDistribuicao, equals(total));
    });
  });
}
