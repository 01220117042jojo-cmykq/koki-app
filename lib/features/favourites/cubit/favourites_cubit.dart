import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../../domain/repository/favourites_repository.dart';
import 'favourites_states.dart';

class FavouritesCubit extends Cubit<FavouritesStates> {
  final FavouritesRepository repository;

  FavouritesCubit({required this.repository}) : super(FavouritesInitialState());

  List<ProductEntity> _favoriteProducts = [];
  Set<String> _favoriteIds = {};

  List<ProductEntity> get favoriteProducts => _favoriteProducts;
  Set<String> get favoriteIds => _favoriteIds;

  Future<void> loadFavorites() async {
    if (FirebaseAuth.instance.currentUser == null) {
      clearFavorites();
      return;
    }

    emit(FavouritesLoadingState());
    try {
      _favoriteProducts = await repository.getFavoriteProducts();
      _favoriteIds = (await repository.getFavoriteProductIds()).toSet();
      emit(FavouritesSuccessState(_favoriteProducts));
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'failed_to_load_favorites'.tr();
      emit(FavouritesErrorState(message));
    }
  }

  void clearFavorites() {
    _favoriteProducts = [];
    _favoriteIds = {};
    emit(FavouritesSuccessState([]));
  }

  Future<void> toggleFavoriteProduct(ProductEntity product) async {
    if (FirebaseAuth.instance.currentUser == null) {
      emit(FavouritesErrorState("please_login_first".tr()));
      return;
    }

    final idStr = product.id.toString();
    try {
      if (_favoriteIds.contains(idStr)) {
        _favoriteIds.remove(idStr);
        _favoriteProducts.removeWhere((p) => p.id.toString() == idStr);
      } else {
        _favoriteIds.add(idStr);
        _favoriteProducts.add(product);
      }
      emit(FavouritesSuccessState(List.from(_favoriteProducts)));

      await repository.toggleFavorite(product);
    } catch (e) {
      await loadFavorites();
      final message = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'failed_to_update_favorite'.tr();
      emit(FavouritesErrorState(message));
    }
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }
}