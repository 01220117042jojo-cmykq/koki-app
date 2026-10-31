import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/features/forget_password/cubit/forget_password_states.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(ForgetPasswordInitialState());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();

  bool isButtonEnabled = false;

  void watchEmailField() {
    if (emailController.text.trim().isNotEmpty) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
    emit(ForgetPasswordValidationState());
  }

  void sendResetEmail() async {
    if (emailFormKey.currentState!.validate()) {
      emit(ForgetPasswordEmailLoadingState());

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        emit(ForgetPasswordEmailSuccessState());
      } on FirebaseAuthException catch (e) {
        String message = 'an_error_occurred'.tr();
        if (e.code == 'user-not-found') {
          message = 'user_not_found'.tr();
        } else if (e.code == 'invalid-email') {
          message = 'invalid_email'.tr();
        } else if (e.code == 'network-request-failed') {
          message = 'network_request_failed'.tr();
        }
        emit(ForgetPasswordEmailErrorState(message));
      } catch (e) {
        emit(ForgetPasswordEmailErrorState('something_went_wrong'.tr()));
      }
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}