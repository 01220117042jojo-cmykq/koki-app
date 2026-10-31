import '../../../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.products,
    required super.total,
    required super.discountedTotal,
    required super.totalProducts,
    required super.totalQuantity,
  });

  factory CartModel.fromItemsList({
    required int userId,
    required List<CartItemModel> items,
  }) {
    double computedTotal = 0;
    int computedQuantity = 0;

    for (var item in items) {
      computedTotal += (item.price * item.quantity);
      computedQuantity += item.quantity;
    }

    return CartModel(
      id: userId,
      products: items,
      total: computedTotal,
      discountedTotal: computedTotal,
      totalProducts: items.length,
      totalQuantity: computedQuantity,
    );
  }
  factory CartModel.empty({required int userId}) {
    return CartModel(
      id: userId,
      products: [],
      total: 0.0,
      discountedTotal: 0.0,
      totalProducts: 0,
      totalQuantity: 0,
    );
  }
}