import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/use_cases/get_products_by_category_use_case.dart';
import 'category_products_states.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsStates> {
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  CategoryProductsCubit(this.getProductsByCategoryUseCase)
    : super(CategoryProductsInitialState());

  static CategoryProductsCubit get(context) =>
      BlocProvider.of<CategoryProductsCubit>(context);

  Future<void> loadAllCategoryProducts(List<CategoryEntity> categories) async {
    emit(CategoryProductsLoadingState());
    try {
      final Map<String, List<ProductEntity>> productsMap = {};
      await Future.wait(
        categories.map((category) async {
          final products = await getProductsByCategoryUseCase.call(
            category.slug,
          );
          productsMap[category.slug] = products;
        }),
      );
      emit(CategoryProductsSuccessState(productsMap));
    } catch (e) {
      emit(CategoryProductsErrorState(e.toString()));
    }
  }
}
