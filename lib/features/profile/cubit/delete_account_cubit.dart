
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/delete_account_use_case.dart';
import 'delete_account_states.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountStates> {
  final DeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountCubit({required this.deleteAccountUseCase})
      : super(DeleteAccountInitialState());

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(DeleteAccountVisibilityChangedState());
  }

  Future<void> deleteAccount({required String password}) async {
    final trimmedPassword = password.trim();

    if (trimmedPassword.isEmpty) {
      emit(DeleteAccountErrorState('enter_password_confirm'));
      return;
    }

    emit(DeleteAccountLoadingState());

    try {
      await deleteAccountUseCase.call(password: trimmedPassword);
      emit(DeleteAccountSuccessState());
    } catch (e) {
      debugPrint("Delete Account Error: $e");
      emit(DeleteAccountErrorState(_mapExceptionToKey(e)));
    }
  }

  String _mapExceptionToKey(Object exception) {
    final errorString = exception.toString().toLowerCase();

    if (errorString.contains('wrong-password') || errorString.contains('invalid-credential')) {
      return 'wrong_password';
    } else if (errorString.contains('user-not-found')) {
      return 'user_not_found';
    } else if (errorString.contains('requires-recent-login')) {
      return 'requires_recent_login';
    }

    return 'unexpected_error';
  }
}