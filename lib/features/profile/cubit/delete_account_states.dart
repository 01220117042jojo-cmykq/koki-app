abstract class DeleteAccountStates {}

class DeleteAccountInitialState extends DeleteAccountStates {}

class DeleteAccountLoadingState extends DeleteAccountStates {}

class DeleteAccountSuccessState extends DeleteAccountStates {}

class DeleteAccountVisibilityChangedState extends DeleteAccountStates {}

class DeleteAccountErrorState extends DeleteAccountStates {
  final String message;

  DeleteAccountErrorState(this.message);
}