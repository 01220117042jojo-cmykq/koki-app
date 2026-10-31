import '../entities/cart_entity.dart';
import '../entities/product_entity.dart';
import '../repository/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<CartEntity> call({
    required int userId,
    required ProductEntity product,
    int quantity = 1,
  }) {
    return repository.addToCart(
      userId: userId,
      product: product,
      quantity: quantity,
    );
  }
}