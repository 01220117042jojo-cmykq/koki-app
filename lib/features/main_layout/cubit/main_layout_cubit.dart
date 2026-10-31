import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_layout_states.dart';

class MainLayoutCubit extends Cubit<MainLayoutStates> {
  MainLayoutCubit() : super(MainLayoutInitialState());

  static MainLayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int selectedCategoryIndex = 0;

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(MainLayoutChangeBottomNavState());
  }

  void navigateToCategory(int index) {
    selectedCategoryIndex = index;
    currentIndex = 1;
    emit(MainLayoutNavigateToCategoryState());
  }
}