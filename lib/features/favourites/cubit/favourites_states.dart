import '../../../domain/entities/product_entity.dart';

abstract class FavouritesStates {}

class FavouritesInitialState extends FavouritesStates {}

class FavouritesLoadingState extends FavouritesStates {}

class FavouritesSuccessState extends FavouritesStates {
  final List<ProductEntity> products;
  FavouritesSuccessState(this.products);
}

class FavouritesErrorState extends FavouritesStates {
  final String message;
  FavouritesErrorState(this.message);
}