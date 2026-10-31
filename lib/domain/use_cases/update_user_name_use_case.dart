import '../repository/profile_repository.dart';

class UpdateUserNameUseCase {
  final ProfileRepository repository;

  UpdateUserNameUseCase({required this.repository});

  Future<void> call(String newName) async {
    return await repository.updateUserName(newName);
  }
}