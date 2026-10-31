
import 'package:koki/domain/entities/product_entity.dart';
import 'package:koki/domain/repository/products_repository.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/offer_entity.dart';
import '../data_sources/remote_data_source/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      final productModels = await remoteDataSource.getAllProducts();

      return productModels;
    } catch (e) {
      throw ServerException('server_error');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    try {
      return await remoteDataSource.searchProducts(query);
    } catch (e) {
      throw ServerException('server_error');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return categoryModels;
    } catch (e) {
      throw ServerException('server_error');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryName) async {
    try {
      final productModels = await remoteDataSource.getProductsByCategory(
        categoryName,
      );
      return productModels;
    } catch (e) {
      throw ServerException('server_error');
    }
  }

  @override
  Future<List<OfferEntity>> getOffers() async {
    try {
      final offerModels = await remoteDataSource.getOffers();
      return offerModels;
    } catch (e) {
      throw ServerException('server_error');
    }
  }

  @override
  Future<ProductEntity> getProductDetails(int id) async {
    try {
      final productModel = await remoteDataSource.getProductDetails(id);
      return productModel;
    } catch (e) {
      throw ServerException('server_error');
    }
  }
}