import '../entities/product_entity.dart';
import '../repository/products_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductsRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<List<ProductEntity>> call(String categoryName) async {
    return await repository.getProductsByCategory(categoryName);
  }
}
