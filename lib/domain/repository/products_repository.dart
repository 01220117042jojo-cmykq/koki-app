import 'package:koki/domain/entities/product_entity.dart';

import '../entities/category_entity.dart';
import '../entities/offer_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getAllProducts();

  Future<List<ProductEntity>> searchProducts(String query);

  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> getProductsByCategory(String categoryName);

  Future<List<OfferEntity>> getOffers();
  Future<ProductEntity> getProductDetails(int id);
}
