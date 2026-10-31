
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../data_sources/remote_data_source/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getUserProfile() async {
    final Map<String, dynamic> userData = await remoteDataSource.getUserProfileData();

    return UserProfileEntity(
      name: userData['name'],
      email: userData['email'],
    );
  }

  @override
  Future<void> logOut() async {
    await remoteDataSource.logOut();
  }

  @override
  Future<void> updateUserName(String newName) async {
    await remoteDataSource.updateUserName(newName);
  }

  @override
  Future<void> changePassword(
      String currentPassword,
      String newPassword,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw const AuthException("user_not_logged_in");
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword.trim());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          throw const AuthException("incorrect_password");

        case 'weak-password':
          throw const AuthException("weak_password");

        case 'requires-recent-login':
          throw const AuthException("requires_recent_login");

        default:
          throw const AuthException("server_error");
      }
    } catch (e) {
      throw const AuthException("server_error");
    }
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    try {
      await remoteDataSource.deleteAccount(password: password);
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw const AuthException("server_error");
    }
  }
}