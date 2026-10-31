import '../entities/cart_entity.dart';
import '../repository/cart_repository.dart';

class CheckoutUseCase {
  final CartRepository repository;

  CheckoutUseCase(this.repository);

  Future<String> call({
    required int userId,
    required CartEntity cart,
    required String paymentMethod,
    required String address,
  }) async {
    return await repository.checkout(
      userId: userId,
      cart: cart,
      paymentMethod: paymentMethod,
      address: address,
    );
  }
}