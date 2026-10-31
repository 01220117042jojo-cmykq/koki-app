import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../domain/entities/product_entity.dart';

abstract class FavouritesRemoteDataSource {
  Future<List<ProductEntity>> getFavoriteProducts();
  Future<List<String>> getFavoriteIds();
  Future<void> addToFavorites(ProductEntity product);
  Future<void> removeFromFavorites(String productId);
}

class FavouritesRemoteDataSourceImpl implements FavouritesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  FavouritesRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  // Firestore Path: /users/{userId}/favorites/{productId}
  CollectionReference? _getUserFavoritesCollection() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return firestore.collection('users').doc(user.uid).collection('favorites');
  }

  @override
  Future<List<String>> getFavoriteIds() async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) return [];

    final snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Future<List<ProductEntity>> getFavoriteProducts() async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) return [];

    final snapshot = await collection.get();
    return snapshot.docs.map((doc) {
      final map = doc.data() as Map<String, dynamic>;
      return ProductEntity(
        id: map['id'],
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        price: (map['price'] as num).toDouble(),
        discountPercentage: (map['discountPercentage'] as num?)?.toDouble() ?? 0.0,
        thumbnail: map['thumbnail'] ?? '',
        images: List<String>.from(map['images'] ?? []),
      );
    }).toList();
  }

  @override
  Future<void> addToFavorites(ProductEntity product) async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) return;

    final map = {
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'discountPercentage': product.discountPercentage,
      'thumbnail': product.thumbnail,
      'images': product.images,
    };

    await collection.doc(product.id.toString()).set(map);
  }

  @override
  Future<void> removeFromFavorites(String productId) async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) return;

    await collection.doc(productId).delete();
  }
}