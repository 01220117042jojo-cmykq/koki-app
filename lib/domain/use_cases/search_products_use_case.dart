import '../entities/product_entity.dart';
import '../repository/products_repository.dart';

class SearchProductsUseCase {
  final ProductsRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<ProductEntity>> call(String query) async {
    return await repository.searchProducts(query);
  }
}