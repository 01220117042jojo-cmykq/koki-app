import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koki/core/error/exceptions.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../model/cart_item_model.dart';
import '../../model/cart_model.dart';
import '../../../../domain/entities/product_entity.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart(int userId);

  Future<CartModel> addToCart({
    required int userId,
    required ProductEntity product,
    required int quantity,
  });

  Future<CartModel> updateCart({
    required int userId,
    required int productId,
    required int quantity,
  });

  Future<CartModel> deleteCartItem({
    required int userId,
    required int productId,
  });

  Future<CartModel> clearCart(int userId);

  Future<String> checkout({
    required int userId,
    required CartEntity cart,
    required String paymentMethod,
    required String address,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSourceImpl({required this.firestore});

  CollectionReference _getUserCartCollection(int userId) {
    return firestore.collection('carts').doc(userId.toString()).collection('items');
  }

  @override
  Future<CartModel> getCart(int userId) async {
    try {
      final snapshot = await _getUserCartCollection(userId).get();

      final items = snapshot.docs.map((doc) {
        return CartItemModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return CartModel.fromItemsList(userId: userId, items: items);
    } catch (e) {
      throw ServerException('Failed to get cart items: $e');
    }
  }

  @override
  Future<CartModel> addToCart({
    required int userId,
    required ProductEntity product,
    required int quantity,
  }) async {
    try {
      final itemRef = _getUserCartCollection(userId).doc(product.id.toString());
      final doc = await itemRef.get();

      if (doc.exists) {
        final currentData = doc.data() as Map<String, dynamic>;
        final currentQty = currentData['quantity'] ?? 0;
        await itemRef.update({'quantity': currentQty + quantity});
      } else {
        final newItem = CartItemModel(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: quantity,
          thumbnail: product.thumbnail,
        );
        await itemRef.set(newItem.toJson());
      }

      return await getCart(userId);
    } catch (e) {
      throw ServerException('Failed to add item to cart: $e');
    }
  }

  @override
  Future<CartModel> updateCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final itemRef = _getUserCartCollection(userId).doc(productId.toString());

      if (quantity <= 0) {
        await itemRef.delete();
      } else {
        await itemRef.update({'quantity': quantity});
      }

      return await getCart(userId);
    } catch (e) {
      throw ServerException('Failed to update cart quantity: $e');
    }
  }

  @override
  Future<CartModel> deleteCartItem({
    required int userId,
    required int productId,
  }) async {
    try {
      await _getUserCartCollection(userId).doc(productId.toString()).delete();
      return await getCart(userId);
    } catch (e) {
      throw ServerException('Failed to delete item from cart: $e');
    }
  }

  @override
  Future<CartModel> clearCart(int userId) async {
    try {
      final snapshot = await _getUserCartCollection(userId).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return CartModel.fromItemsList(userId: userId, items: []);
    } catch (e) {
      throw ServerException('Failed to clear cart: $e');
    }
  }

  @override
  Future<String> checkout({
    required int userId,
    required CartEntity cart,
    required String paymentMethod,
    required String address,
  }) async {
    try {
      final orderRef = firestore.collection('orders').doc();
      final orderId = orderRef.id;

      final double subTotal = cart.total;
      const double vat = 20.0;
      const double deliveryFee = 26.0;
      final double finalTotalPrice = subTotal + vat + deliveryFee;

      final orderData = {
        'orderId': orderId,
        'userId': userId,
        'items': cart.products.map((item) => {
          'id': item.id,
          'title': item.title,
          'price': item.price,
          'quantity': item.quantity,
          'thumbnail': item.thumbnail,
        }).toList(),
        'subTotal': subTotal,
        'vat': vat,
        'deliveryFee': deliveryFee,
        'totalPrice': finalTotalPrice,
        'totalQuantity': cart.totalQuantity,
        'paymentMethod': paymentMethod,
        'address': address.trim().isNotEmpty ? address : 'Cairo, Egypt',
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await orderRef.set(orderData);
      await clearCart(userId);

      return orderId;
    } catch (e) {
      throw ServerException('Failed to complete checkout: $e');
    }
  }
}