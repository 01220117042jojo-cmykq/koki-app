import '../entities/cart_entity.dart';
import '../entities/product_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart(int userId);

  Future<CartEntity> addToCart({
    required int userId,
    required ProductEntity product,
    required int quantity,
  });

  Future<CartEntity> updateCartItemQuantity({
    required int userId,
    required int productId,
    required int newQuantity,
  });

  Future<CartEntity> deleteCartItem({
    required int userId,
    required int productId,
  });

  Future<CartEntity> clearCart(int userId);
  Future<String> checkout({
    required int userId,
    required CartEntity cart,
    required String paymentMethod,
    required String address,
  });
}