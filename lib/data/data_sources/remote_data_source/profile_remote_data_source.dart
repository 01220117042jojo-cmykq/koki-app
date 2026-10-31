import 'package:firebase_auth/firebase_auth.dart';
import 'package:koki/core/error/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getUserProfileData();
  Future<void> logOut();
  Future<void> updateUserName(String newName);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount({String? password});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth auth;

  ProfileRemoteDataSourceImpl({FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>> getUserProfileData() async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        throw const AuthException("User is not logged in");
      }

      return {
        'name': user.displayName ?? "User",
        'email': user.email ?? "No Email",
      };
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Failed to load profile data: $e");
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw AuthException("Failed to log out: $e");
    }
  }

  @override
  Future<void> updateUserName(String newName) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName.trim());
        await user.reload();
      } else {
        throw const AuthException("User is not logged in");
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Failed to update profile name");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Failed to update profile name: $e");
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = auth.currentUser;
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword.trim(),
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword.trim());
      } else {
        throw const AuthException("User is not logged in");
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Failed to change password. Please check your credentials.");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Failed to change password: $e");
    }
  }

  @override
  Future<void> deleteAccount({String? password}) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw const AuthException("User is not logged in");
      }

      if (password != null && password.isNotEmpty && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password.trim(),
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw const AuthException("Incorrect password. Please try again.");
      }
      throw AuthException(e.message ?? "Failed to delete account.");
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("Failed to delete account: $e");
    }
  }
}