import '../entities/product_entity.dart';

abstract class FavouritesRepository {
  Future<List<String>> getFavoriteProductIds();
  Future<List<ProductEntity>> getFavoriteProducts();
  Future<void> toggleFavorite(ProductEntity product);
  Future<bool> isFavorite(String productId);
}