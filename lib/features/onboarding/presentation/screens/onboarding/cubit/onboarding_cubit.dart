import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/features/onboarding/presentation/screens/onboarding/cubit/onboarding_states.dart';

class OnboardingCubit extends Cubit<OnboardingStates>
{
  OnboardingCubit() : super(OnboardingInitialState());

  final PageController pageController = PageController();
  int currentIndex = 0 ;

  void changePage(int index) {
    currentIndex = index ;
    emit(OnboardingPageChangedState(pageIndex: currentIndex));
  }
  void nextLength(int totalPages) {
    if ( currentIndex < totalPages -1) {
      pageController.nextPage
        (
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    } else {

    }
  }
  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}