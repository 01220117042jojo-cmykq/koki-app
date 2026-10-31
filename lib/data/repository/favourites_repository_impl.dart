import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/repository/favourites_repository.dart';
import '../data_sources/remote_data_source/favourites_remote_data_source.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesRemoteDataSource remoteDataSource;

  FavouritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<String>> getFavoriteProductIds() async {
    return await remoteDataSource.getFavoriteIds();
  }

  @override
  Future<List<ProductEntity>> getFavoriteProducts() async {
    return await remoteDataSource.getFavoriteProducts();
  }

  @override
  Future<void> toggleFavorite(ProductEntity product) async {
    final idStr = product.id.toString();
    final favoriteIds = await remoteDataSource.getFavoriteIds();

    if (favoriteIds.contains(idStr)) {
      await remoteDataSource.removeFromFavorites(idStr);
    } else {
      await remoteDataSource.addToFavorites(product);
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    final favoriteIds = await remoteDataSource.getFavoriteIds();
    return favoriteIds.contains(productId);
  }
}