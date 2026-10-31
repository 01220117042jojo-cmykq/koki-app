import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/core/di/service_locator.dart';
import 'package:koki/domain/use_cases/login_use_case.dart';
import 'package:koki/features/auth/presentation/screens/login/cubit/login_states.dart';
import 'package:koki/features/cart/cubit/cart_cubit.dart';
import '../../../../../favourites/cubit/favourites_cubit.dart';

import '../../../../../location/cubit/location_cubit.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitialState()) {
    emailController.addListener(watchFields);
    passwordController.addListener(watchFields);
  }

  static LoginCubit get(context) => BlocProvider.of(context);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isRemeberMeChecked = false;
  bool isButtonEnabled = false;

  void changePassword() {
    isPasswordHidden = !isPasswordHidden;
    emit(ChangePasswordState());
  }

  void watchFields() {
    isButtonEnabled = emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;

    emit(LogiValidationState());
  }

  void changeRememberMe(bool? value) {
    isRemeberMeChecked = value ?? false;
    emit(ChangeRememberMeState());
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());

      try {
        final result = await loginUseCase.call(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final uid = result.user?.uid;

        if (uid != null) {
          getIt<FavouritesCubit>().loadFavorites();
          getIt<CartCubit>().getCart(uid.hashCode.abs());
          getIt<LocationCubit>().syncGuestAddressToFirebase();
        }

        emit(LoginSuccessState(uid ?? ""));
      } on FirebaseAuthException catch (e) {
        emit(LoginErrorState(_mapFirebaseAuthError(e.code)));
      } catch (e) {
        emit(LoginErrorState('something_went_wrong'.tr()));
      }
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
        return 'invalid_credentials_error'.tr();
      case 'user-not-found':
        return 'user_not_found_error'.tr();
      case 'user-disabled':
        return 'user_disabled_error'.tr();
      case 'too-many-requests':
        return 'too_many_requests_error'.tr();
      case 'network-request-failed':
        return 'check_internet_connection'.tr();
      case 'invalid-email':
        return 'invalid_email_format'.tr();
      default:
        return 'unexpected_error'.tr();
    }
  }

  @override
  Future<void> close() {
    emailController.removeListener(watchFields);
    passwordController.removeListener(watchFields);
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}