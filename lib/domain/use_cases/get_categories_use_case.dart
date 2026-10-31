import '../entities/category_entity.dart';
import '../repository/products_repository.dart';

class GetCategoriesUseCase {
  final ProductsRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> execute() async {
    return await repository.getCategories();
  }
}
