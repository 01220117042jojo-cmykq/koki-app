import '../entities/cart_entity.dart';
import '../repository/cart_repository.dart';

class UpdateCartUseCase {
  final CartRepository repository;

  UpdateCartUseCase(this.repository);

  Future<CartEntity> call({
    required int userId,
    required int productId,
    required int newQuantity,
  }) {
    return repository.updateCartItemQuantity(
      userId: userId,
      productId: productId,
      newQuantity: newQuantity,
    );
  }
}