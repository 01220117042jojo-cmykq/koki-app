import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/product_entity.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeGetProductsLoadingState extends HomeStates {}

class HomeGetProductsSuccessState extends HomeStates {
  final List<ProductEntity> products;

  HomeGetProductsSuccessState(this.products);
}

class HomeGetProductsErrorState extends HomeStates {
  final String errorMessage;

  HomeGetProductsErrorState(this.errorMessage);
}

class HomeSearchProductsLoadingState extends HomeStates {}

class HomeSearchProductsSuccessState extends HomeStates {
  final List<ProductEntity> products;

  HomeSearchProductsSuccessState(this.products);
}

class HomeSearchProductsErrorState extends HomeStates {
  final String errorMessage;

  HomeSearchProductsErrorState(this.errorMessage);
}

class HomeGetCategoriesLoadingState extends HomeStates {}

class HomeGetCategoriesSuccessState extends HomeStates {
  final List<CategoryEntity> categories;

  HomeGetCategoriesSuccessState(this.categories);
}

class HomeGetCategoriesErrorState extends HomeStates {
  final String errorMessage;

  HomeGetCategoriesErrorState(this.errorMessage);
}

class HomeGetTabletsLoadingState extends HomeStates {}

class HomeGetTabletsSuccessState extends HomeStates {
  final List<ProductEntity> products;

  HomeGetTabletsSuccessState(this.products);
}

class HomeGetTabletsErrorState extends HomeStates {
  final String errorMessage;

  HomeGetTabletsErrorState(this.errorMessage);
}

/// try beauty
class HomeGetBeautyLoadingState extends HomeStates {}

class HomeGetBeautySuccessState extends HomeStates {
  final List<ProductEntity> products;

  HomeGetBeautySuccessState(this.products);
}

class HomeGetBeautyErrorState extends HomeStates {
  final String errorMessage;

  HomeGetBeautyErrorState(this.errorMessage);
}

/// try skin care
class HomeGetSkinCareLoadingState extends HomeStates {}

class HomeGetSkinCareSuccessState extends HomeStates {
  final List<ProductEntity> products;

  HomeGetSkinCareSuccessState(this.products);
}

class HomeGetSkinCareErrorState extends HomeStates {
  final String errorMessage;

  HomeGetSkinCareErrorState(this.errorMessage);
}

class HomeGetWomensBagsLoadingState extends HomeStates {}

class HomeGetWomensBagsSuccessState extends HomeStates {
  final List<ProductEntity> products;

  HomeGetWomensBagsSuccessState(this.products);
}

class HomeGetWomensBagsErrorState extends HomeStates {
  final String errorMessage;

  HomeGetWomensBagsErrorState(this.errorMessage);
}
