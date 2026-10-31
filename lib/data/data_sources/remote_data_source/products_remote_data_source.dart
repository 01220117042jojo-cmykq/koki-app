import 'package:dio/dio.dart';
import 'package:koki/core/error/exceptions.dart';
import 'package:koki/data/model/category_model.dart';
import 'package:koki/data/model/product_model.dart';

import '../../model/offer_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();

  Future<List<ProductModel>> searchProducts(String query);

  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getProductsByCategory(String categoryName);

  Future<List<OfferModel>> getOffers();

  Future<ProductModel> getProductDetails(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio dio;

  ProductsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await dio.get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> productsList = data['products'];

        return productsList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Failed to load products: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> productsList = data['products'];
        return productsList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to search products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Failed to search products: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products/categories',
      );
      if (response.statusCode == 200) {
        final List<dynamic> categoriesList = response.data;
        return categoriesList
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to load categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Failed to load categories: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryName) async {
    try {
      final response = await dio.get(
        'https://dummyjson.com/products/category/$categoryName',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> productsList = data['products'];
        return productsList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to load products by category: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Failed to load products by category: $e');
    }
  }

  @override
  Future<List<OfferModel>> getOffers() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final List<Map<String, dynamic>> mockOffersJson = [
        {
          "id": 1,
          "imageUrl":
          "https://kokishoponline.com/wp-content/uploads/2025/05/Untitled-1-Image@4x-1.png",
          "title": "koki fresh",
        },
        {
          "id": 2,
          "imageUrl":
          "https://kokishoponline.com/wp-content/uploads/2025/05/1-1.png",
          "title": "koki heroz",
        },
        {
          "id": 3,
          "imageUrl":
          "https://kokishoponline.com/wp-content/uploads/2025/04/STRIPS-400-1.png",
          "title": "koki strips",
        },
      ];
      return mockOffersJson.map((json) => OfferModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to load offers: $e');
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    try {
      final response = await dio.get('https://dummyjson.com/products/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data;
        return ProductModel.fromJson(json);
      } else {
        throw ServerException(
          'Failed to load product details: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Failed to load product details: $e');
    }
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.error.toString().contains('SocketException')) {
      throw const NetworkException('Please check your internet connection');
    }
    throw ServerException(e.message ?? 'Server error occurred');
  }
}