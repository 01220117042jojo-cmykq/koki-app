import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../domain/use_cases/get_user_profile_use_case.dart';
import '../../../core/di/service_locator.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../favourites/cubit/favourites_cubit.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileCubit({required this.getUserProfileUseCase}) : super(ProfileInitialState());

  void getProfileData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      emit(ProfileUnauthenticatedState());
      return;
    }

    emit(ProfileLoadingState());

    try {
      final userProfile = await getUserProfileUseCase.call();
      emit(ProfileAuthenticatedState(userProfile));
    } catch (e) {
      final message = e is Exception ? e.toString().replaceAll('Exception: ', '') : 'Failed to fetch profile';
      emit(ProfileErrorState(message));
    }
  }
  void logOutUser() async {
    emit(ProfileLoadingState());
    try {
      await getUserProfileUseCase.repository.logOut();

      getIt<FavouritesCubit>().clearFavorites();
      await getIt<CartCubit>().clearLocalAndStateCart();

      emit(ProfileUnauthenticatedState());
    } catch (e) {
      final message = e is Exception ? e.toString().replaceAll('Exception: ', '') : 'Failed to log out';
      emit(ProfileErrorState(message));
    }
  }
}
//