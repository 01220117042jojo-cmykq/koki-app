import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/model/cart_model.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/use_cases/add_to_cart_use_case.dart';
import '../../../domain/use_cases/checkout_use_case.dart';
import '../../../domain/use_cases/get_cart_use_case.dart';
import '../../../domain/use_cases/update_cart_use_case.dart';
import '../../../domain/use_cases/delete_cart_use_case.dart';
import 'cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartUseCase updateCartUseCase;
  final DeleteCartUseCase deleteCartUseCase;
  final CheckoutUseCase checkoutUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartUseCase,
    required this.deleteCartUseCase,
    required this.checkoutUseCase,
  }) : super(CartInitialState());

  static const int guestUserId = 0;

  Future<void> getCart(int? userId) async {
    final bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
    final int effectiveUserId = isUserLoggedIn ? (userId ?? 0) : 0;

    emit(CartLoadingState());
    try {
      final cart = await getCartUseCase(effectiveUserId);
      emit(CartSuccessState(cart));
    } catch (e) {
      emit(CartErrorState('something_went_wrong'.tr()));
    }
  }

  Future<void> addToCart({
    int? userId,
    required ProductEntity product,
    int quantity = 1,
  }) async {
    final bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
    final effectiveUserId = isUserLoggedIn ? (userId ?? guestUserId) : guestUserId;
    CartEntity? previousCart;

    if (state is CartSuccessState) {
      previousCart = (state as CartSuccessState).cart;
      emit(CartActionLoadingState(previousCart));
    } else {
      emit(CartLoadingState());
    }

    try {
      final updatedCart = await addToCartUseCase(
        userId: effectiveUserId,
        product: product,
        quantity: quantity,
      );
      emit(CartSuccessState(updatedCart));
    } catch (e) {
      if (previousCart != null) {
        emit(CartSuccessState(previousCart));
      } else {
        emit(CartErrorState(
          e is ServerException ? e.message : 'something_went_wrong'.tr(),
        ));
      }
    }
  }

  Future<void> updateCartQuantity({
    int? userId,
    required int productId,
    required int newQuantity,
  }) async {
    if (state is! CartSuccessState) return;

    final bool isUserLoggedIn = FirebaseAuth.instance.currentUser != null;
    final effectiveUserId = isUserLoggedIn ? (userId ?? guestUserId) : guestUserId;
    final currentCart = (state as CartSuccessState).cart;

    final updatedProducts = currentCart.products.map((item) {
      if (item.id.toString() == productId.toString()) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).where((item) => item.quantity > 0).toList();

    double newTotal = 0.0;
    int newTotalQuantity = 0;
    for (var item in updatedProducts) {
      newTotal += (item.price * item.quantity);
      newTotalQuantity += item.quantity;
    }

    final localCart = currentCart.copyWith(
      products: updatedProducts,
      total: newTotal,
      totalQuantity: newTotalQuantity,
      totalProducts: updatedProducts.length,
    );

    emit(CartSuccessState(localCart));

    try {
      final serverCart = await updateCartUseCase(
        userId: effectiveUserId,
        productId: productId,
        newQuantity: newQuantity,
      );
      emit(CartSuccessState(serverCart));
    } catch (e) {
      emit(CartSuccessState(currentCart));
    }
  }

  Future<void> clearCart(int? userId) async {
    final effectiveUserId = userId ?? guestUserId;
    emit(CartLoadingState());
    try {
      await deleteCartUseCase(effectiveUserId);
      emit(CartInitialState());
    } catch (e) {
      emit(CartErrorState(
        e is ServerException ? e.message : 'something_went_wrong'.tr(),
      ));
    }
  }

  Future<void> checkout({
    int? userId,
    required String paymentMethod,
    required String address,
  }) async {
    if (state is! CartSuccessState) return;

    final effectiveUserId = userId ?? guestUserId;
    final currentCart = (state as CartSuccessState).cart;
    emit(CheckoutLoadingState());

    try {
      final orderId = await checkoutUseCase(
        userId: effectiveUserId,
        cart: currentCart,
        paymentMethod: paymentMethod,
        address: address,
      );
      emit(CheckoutSuccessState(orderId));
    } catch (e) {
      emit(CheckoutErrorState(e.toString()));
    }
  }

  Future<void> clearLocalAndStateCart() async {
    try {
      await deleteCartUseCase(0);
    } catch (e) {
      print('Error clearing cart: $e');
    } finally {
      emit(CartSuccessState(CartModel.empty(userId: 0)));
    }
  }
}