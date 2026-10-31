import '../../../domain/entities/category_entity.dart';

abstract class CategoryStates {}

class CategoryInitialState extends CategoryStates {}

class CategoryLoadingState extends CategoryStates {}

class CategorySuccessState extends CategoryStates {
  final List<CategoryEntity> categories;

  CategorySuccessState(this.categories);
}

class CategoryErrorState extends CategoryStates {
  final String errorMessage;

  CategoryErrorState(this.errorMessage);
}