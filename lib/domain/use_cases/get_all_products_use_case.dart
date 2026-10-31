import '../entities/product_entity.dart';
import '../repository/products_repository.dart';

class GetAllProductsUseCase {
  final ProductsRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<List<ProductEntity>> call() async {
    return await repository.getAllProducts();
  }
}
