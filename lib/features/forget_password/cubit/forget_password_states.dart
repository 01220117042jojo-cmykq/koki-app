abstract class ForgetPasswordStates {}
class ForgetPasswordInitialState extends ForgetPasswordStates {}
class ForgetPasswordEmailLoadingState extends ForgetPasswordStates {}
class ForgetPasswordEmailSuccessState extends ForgetPasswordStates {}
class ForgetPasswordEmailErrorState extends ForgetPasswordStates {
  final String error ;
  ForgetPasswordEmailErrorState(this.error);
}
 class ForgetPasswordValidationState extends ForgetPasswordStates {}


