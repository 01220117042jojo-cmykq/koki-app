import 'package:firebase_auth/firebase_auth.dart';
import 'package:koki/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository ;

  LoginUseCase({required this.repository});

  Future<UserCredential> call ({
    required String email,
    required String password
}) async {
    return await repository.login(email: email, password: password);
  }
}