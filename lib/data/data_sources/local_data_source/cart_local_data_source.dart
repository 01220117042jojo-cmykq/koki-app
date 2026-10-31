import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/cart_item_model.dart';

class CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  CartLocalDataSource(this.sharedPreferences);

  Future<void> saveLocalCart(List<CartItemModel> items) async {
    try {
      final List<String> jsonList =
      items.map((e) => jsonEncode(e.toJson())).toList();
      final success = await sharedPreferences.setStringList('guest_cart', jsonList);
      print('🚨 SAVE LOCAL CART STATUS: $success | Saved Items Count: ${items.length}');
    } catch (e) {
      print('🚨 ERROR SAVING LOCAL CART: $e');
    }
  }
  Future<List<CartItemModel>> getLocalCart() async {
    try {
      await sharedPreferences.reload();

      final jsonList = sharedPreferences.getStringList('guest_cart') ?? [];
      print('🚨 READ JSON LIST FROM DISK: ${jsonList.length} items');

      return jsonList.map((e) {
        final Map<String, dynamic> decodedMap = jsonDecode(e);
        return CartItemModel.fromJson(decodedMap);
      }).toList();
    } catch (e) {
      print('🚨 ERROR READING LOCAL CART: $e');
      return [];
    }
  }

  Future<void> clearLocalCart() async {
    await sharedPreferences.remove('guest_cart');
    print('🚨 GUEST CART CLEARED FROM DISK');
  }
}