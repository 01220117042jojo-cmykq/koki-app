import '../../../../domain/entities/cart_entity.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/repository/cart_repository.dart';
import '../data_sources/local_data_source/cart_local_data_source.dart';
import '../data_sources/remote_data_source/cart_remote_data_source.dart';
import '../model/cart_item_model.dart';
import '../model/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<CartEntity> getCart(int userId) async {
    print('🚨 GET CART CALL = userId is: $userId');
    if (userId == 0) {
      final items = await localDataSource.getLocalCart();
      print('🚨 LOCAL ITEMS IN GUEST CART: ${items.length}');
      for (var i in items) {
        print('item: ${i.title}');
      }
      return CartModel.fromItemsList(userId: 0, items: items);
    }
    return await remoteDataSource.getCart(userId);
  }
  @override
  // Future<CartEntity> addToCart({required int userId, required ProductEntity product, required int quantity}) async {
  //   if (userId == 0) {
  //     var items = await localDataSource.getLocalCart();
  //
  //       final index = items.indexWhere((item) => item.id == product.id);
  //     if (index >= 0) {
  //       final existingItem = items[index];
  //       items[index] = CartItemModel(
  //         id: existingItem.id,
  //         title: existingItem.title,
  //         price: existingItem.price,
  //         quantity: existingItem.quantity + quantity,
  //         thumbnail: existingItem.thumbnail,
  //       );
  //     } else {
  //       items.add(CartItemModel(
  //         id: product.id,
  //         title: product.title,
  //         price: product.price,
  //         quantity: quantity,
  //         thumbnail: product.thumbnail,
  //       ));
  //     }
  //
  //     await localDataSource.saveLocalCart(items);
  //     return CartModel.fromItemsList(userId: 0, items: items);
  //   }
  //   return await remoteDataSource.addToCart(userId: userId, product: product, quantity: quantity);
  // }
  @override
  Future<CartModel> addToCart({
    required int userId,
    required ProductEntity product,
    required int quantity,
  }) async {
    if (userId == 0) {
      var items = await localDataSource.getLocalCart();

      final index = items.indexWhere((item) => item.id == product.id);
      if (index >= 0) {
        final existingItem = items[index];
        items[index] = CartItemModel(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + quantity,
          thumbnail: existingItem.thumbnail,
        );
      } else {
        items.add(CartItemModel(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: quantity,
          thumbnail: product.thumbnail,
        ));
      }

      await localDataSource.saveLocalCart(items);
      return CartModel.fromItemsList(userId: 0, items: items);
    } else {
      return await remoteDataSource.addToCart(
        userId: userId,
        product: product,
        quantity: quantity,
      );

    }
  }

  @override
  Future<CartEntity> updateCartItemQuantity({
    required int userId,
    required int productId,
    required int newQuantity,
  }) async {
    if (userId == 0) {
      var items = await localDataSource.getLocalCart();
      final index = items.indexWhere((item) => item.id.toString() == productId.toString());
      if (index >= 0) {
        if (newQuantity <= 0) {
          items.removeAt(index);
        } else {
          final existingItem = items[index];
          items[index] = CartItemModel(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantity: newQuantity,
            thumbnail: existingItem.thumbnail,
          );
        }
        await localDataSource.saveLocalCart(items);
      }
      return CartModel.fromItemsList(userId: 0, items: items);
    }
    else {
      return await remoteDataSource.updateCart(
        userId: userId,
        productId: productId,
        quantity: newQuantity,
      );
    }
  }

  @override
  Future<CartEntity> deleteCartItem({
    required int userId,
    required int productId,
  }) async {
    if (userId == 0) {
      var items = await localDataSource.getLocalCart();
      items.removeWhere((item) => item.id.toString() == productId.toString());
      await localDataSource.saveLocalCart(items);

      return CartModel.fromItemsList(userId: 0, items: items);
    }
    else {
      return await remoteDataSource.deleteCartItem(
        userId: userId,
        productId: productId,
      );
    }
  }

  @override
  Future<CartEntity> clearCart(int userId) async {
    if (userId == 0) {
      await localDataSource.clearLocalCart();
      return CartModel.empty(userId: 0);
    }
    return await remoteDataSource.clearCart(userId);
  }

  @override
  Future<String> checkout({
    required int userId,
    required CartEntity cart,
    required String paymentMethod,
    required String address,
  }) async {
    return await remoteDataSource.checkout(
      userId: userId,
      cart: cart,
      paymentMethod: paymentMethod,
      address: address,
    );
  }
}