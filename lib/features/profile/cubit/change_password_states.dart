abstract class ChangePasswordStates {}

class ChangePasswordInitialState extends ChangePasswordStates {}

class ChangePasswordLoadingState extends ChangePasswordStates {}

class ChangePasswordSuccessState extends ChangePasswordStates {}

class ChangePasswordErrorState extends ChangePasswordStates {
  final String message;

  ChangePasswordErrorState(this.message);
}