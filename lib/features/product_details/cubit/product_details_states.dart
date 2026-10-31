import 'package:koki/domain/entities/product_entity.dart';

abstract class ProductDetailsStates {}
class ProductDetailsInitialState extends ProductDetailsStates {}
class ProductDetailsLoadingState extends ProductDetailsStates {}
class ProductDetailsSuccessState extends ProductDetailsStates {
  final ProductEntity product;
  ProductDetailsSuccessState(this.product);
}
class ProductDetailsErrorState extends ProductDetailsStates {
  final String errorMessage;
  ProductDetailsErrorState(this.errorMessage);
}
class ProductImageChangedState extends ProductDetailsStates {
  final int index;
  ProductImageChangedState(this.index);
}
class ProductQuantityChangedState extends ProductDetailsStates {
  final int quantity;
  ProductQuantityChangedState(this.quantity);
}
class AddToCartLoadingState extends ProductDetailsStates {}

class AddToCartSuccessState extends ProductDetailsStates {
  final String message;
  AddToCartSuccessState(this.message);
}
class AddToCartErrorState extends ProductDetailsStates {
  final String errorMessage;
  AddToCartErrorState(this.errorMessage);
}

