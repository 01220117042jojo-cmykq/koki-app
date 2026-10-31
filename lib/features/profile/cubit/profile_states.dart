import '../../../../domain/entities/user_profile_entity.dart';

abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileUnauthenticatedState extends ProfileStates {}

class ProfileAuthenticatedState extends ProfileStates {
  final UserProfileEntity userProfile;

  ProfileAuthenticatedState(this.userProfile);
}

class ProfileErrorState extends ProfileStates {
  final String message;

  ProfileErrorState(this.message);
}