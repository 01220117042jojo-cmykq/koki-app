import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/update_user_name_use_case.dart';
import 'update_profile_states.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileStates> {
  final UpdateUserNameUseCase updateUserNameUseCase;

  UpdateProfileCubit({required this.updateUserNameUseCase})
      : super(UpdateProfileInitialState());

  Future<void> updateUserName(String newName) async {
    emit(UpdateProfileLoadingState());
    try {
      await updateUserNameUseCase.call(newName);
      emit(UpdateProfileSuccessState());
    } catch (e) {
      emit(UpdateProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}