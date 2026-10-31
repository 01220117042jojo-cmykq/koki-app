import 'cart_item_entity.dart';

class CartEntity {
  final int id;
  final List<CartItemEntity> products;
  final double total;
  final double discountedTotal;
  final int totalProducts;
  final int totalQuantity;

  const CartEntity({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.totalProducts,
    required this.totalQuantity,
  });

  CartEntity copyWith({
    int? id,
    List<CartItemEntity>? products,
    double? total,
    double? discountedTotal,
    int? totalProducts,
    int? totalQuantity,
  }) {
    return CartEntity(
      id: id ?? this.id,
      products: products ?? this.products,
      total: total ?? this.total,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      totalProducts: totalProducts ?? this.totalProducts,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}