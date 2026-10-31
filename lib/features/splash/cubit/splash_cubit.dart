import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  final SharedPreferences sharedPreferences;

  SplashCubit(this.sharedPreferences) : super(SplashInitialState());

  Future<void> checkNavigationTarget() async {
    await Future.delayed(const Duration(seconds: 3));

    final isLanguageSelected = sharedPreferences.getBool('isLanguageSelected') ?? false;
    final isFirstTime = sharedPreferences.getBool('isFirstTime') ?? true;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (!isLanguageSelected || isFirstTime) {
      emit(NavigateToOnboardingState());
    } else if (currentUser != null) {
      emit(NavigateToMainLayoutState());
    } else {
      emit(NavigateToLoginState());
    }
  }
}