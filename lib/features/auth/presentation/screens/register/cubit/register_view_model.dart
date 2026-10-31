import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/core/di/service_locator.dart';
import 'package:koki/features/auth/presentation/screens/register/cubit/register_states.dart';
import 'package:koki/features/cart/cubit/cart_cubit.dart';
import 'package:koki/features/favourites/cubit/favourites_cubit.dart';

import '../../../../../../domain/use_cases/register_use_case.dart';
import '../../../../../location/cubit/location_cubit.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase})
      : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isOffersChecked = false;
  bool isButtonEnabled = false;

  void changePassword() {
    isPasswordHidden = !isPasswordHidden;
    emit(RegisterChangePasswordState());
  }

  void changeOffersCheckbox(bool? value) {
    isOffersChecked = value ?? false;
    emit(RegisterChangeOffersCheckboxState());
  }

  void watchFields() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
    emit(RegisterValidationState());
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());

      try {
        final result = await registerUseCase.call(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim(),
        );

        final uid = result.user?.uid;

        if (uid != null) {
          getIt<FavouritesCubit>().loadFavorites();
          getIt<CartCubit>().getCart(uid.hashCode.abs());
          getIt<LocationCubit>().syncGuestAddressToFirebase();

          emit(RegisterSuccessState(uid));
        } else {
          emit(RegisterErrorState('auth_failed_try_again'.tr()));
        }
      } on FirebaseAuthException catch (e) {
        emit(RegisterErrorState(_mapFirebaseAuthError(e.code)));
      } catch (e) {
        emit(RegisterErrorState('something_went_wrong'.tr()));
      }
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'email_already_registered'.tr();
      case 'weak-password':
        return 'weak_password_error'.tr();
      case 'invalid-email':
        return 'invalid_email_format'.tr();
      case 'network-request-failed':
        return 'check_internet_connection'.tr();
      default:
        return 'unexpected_error'.tr();
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}