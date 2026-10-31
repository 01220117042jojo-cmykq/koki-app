import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<UserCredential> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}