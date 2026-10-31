import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/get_categories_use_case.dart';
import 'category_states.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryCubit(this.getCategoriesUseCase) : super(CategoryInitialState());

  static CategoryCubit get(context) => BlocProvider.of<CategoryCubit>(context);

  Future<void> getCategories() async {
    emit(CategoryLoadingState());
    try {
      final categories = await getCategoriesUseCase.execute();
      emit(CategorySuccessState(categories));
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }
}
