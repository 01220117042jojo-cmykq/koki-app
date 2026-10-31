import '../entities/cart_entity.dart';
import '../repository/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<CartEntity> call(int userId) async {
    return await repository.getCart(userId);
  }
}