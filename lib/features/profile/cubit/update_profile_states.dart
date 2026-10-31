abstract class UpdateProfileStates {}

class UpdateProfileInitialState extends UpdateProfileStates {}

class UpdateProfileLoadingState extends UpdateProfileStates {}

class UpdateProfileSuccessState extends UpdateProfileStates {}

class UpdateProfileErrorState extends UpdateProfileStates {
  final String message;

  UpdateProfileErrorState(this.message);
}