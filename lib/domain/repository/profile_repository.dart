import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<void> logOut();
  Future<void> updateUserName(String newName);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount({String? password});
}