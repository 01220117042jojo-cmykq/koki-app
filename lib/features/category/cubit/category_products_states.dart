import '../../../domain/entities/product_entity.dart';

abstract class CategoryProductsStates {}

class CategoryProductsInitialState extends CategoryProductsStates {}

class CategoryProductsLoadingState extends CategoryProductsStates {}

class CategoryProductsSuccessState extends CategoryProductsStates {
  final Map<String, List<ProductEntity>> categoryProducts;

  CategoryProductsSuccessState(this.categoryProducts);
}

class CategoryProductsErrorState extends CategoryProductsStates {
  final String errorMessage;

  CategoryProductsErrorState(this.errorMessage);
}
