import 'package:koki/domain/repository/products_repository.dart';

import '../entities/product_entity.dart';

class GetProductDetailsUseCase {
  final ProductsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<ProductEntity> call(int id) async {
    return await repository.getProductDetails(id);
  }
}
