import '../../../domain/entities/cart_entity.dart';

abstract class CartStates {}

class CartInitialState extends CartStates {}

class CartLoadingState extends CartStates {}

class CartSuccessState extends CartStates {
  final CartEntity cart;
  CartSuccessState(this.cart);
}

class CartErrorState extends CartStates {
  final String message;
  CartErrorState(this.message);
}

class CartActionLoadingState extends CartStates {
  final CartEntity previousCart;
  CartActionLoadingState(this.previousCart);
}
class CheckoutLoadingState extends CartStates {}
class CheckoutSuccessState extends CartStates {
  final String orderId ;
  CheckoutSuccessState(this.orderId);
}
class CheckoutErrorState extends CartStates {
  final String message;
  CheckoutErrorState(this.message);
}