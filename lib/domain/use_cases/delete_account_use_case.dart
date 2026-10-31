import '../repository/profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase({required this.repository});

  Future<void> call({String? password}) async {
    return await repository.deleteAccount(password: password);
  }
}