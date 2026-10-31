import '../../../../domain/entities/product_entity.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}
class ProductsSuccess extends ProductsState {
  final List<ProductEntity> products;
  ProductsSuccess(this.products);
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}