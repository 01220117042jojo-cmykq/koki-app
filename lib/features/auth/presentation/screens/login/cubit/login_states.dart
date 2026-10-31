  abstract class LoginStates {}
class LoginInitialState extends LoginStates {}
class LogiValidationState extends LoginStates {}
class ChangePasswordState extends LoginStates {}
class ChangeRememberMeState extends LoginStates {}
class LoginLoadingState extends LoginStates {}
class LoginSuccessState extends  LoginStates{
  final String uId ;
  LoginSuccessState(this.uId);
}
class LoginErrorState extends LoginStates{
  final String error ;
  LoginErrorState(this.error);
}