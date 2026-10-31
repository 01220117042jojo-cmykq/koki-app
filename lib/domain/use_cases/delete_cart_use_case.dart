import '../repository/cart_repository.dart';

class DeleteCartUseCase {
  final CartRepository repository;

  DeleteCartUseCase(this.repository);

  Future<void> call(int userId) {
    return repository.clearCart(userId);
  }
}