import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/change_password_use_case.dart';
import 'change_password_states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
      : super(ChangePasswordInitialState());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    try {
      await changePasswordUseCase.call(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(ChangePasswordSuccessState());
    } catch (e) {
      emit(ChangePasswordErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}