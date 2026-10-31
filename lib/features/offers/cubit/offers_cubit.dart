import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/features/offers/cubit/offers_states.dart';
import '../../../domain/use_cases/get_offers_use_case.dart';

class OffersCubit extends Cubit<OffersStates> {
  final GetOffersUseCase getOffersUseCase;

  OffersCubit({required this.getOffersUseCase}) : super(OffersInitialState());

  Future<void> loadOffers() async {
    emit(OffersLoadingState());
    try {
      final offers = await getOffersUseCase.call();
      emit(OffersSuccessState(offers));
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'failed_to_load_offers';
      emit(OffersErrorState(message));
    }
  }

  void changeIndex(int index) {
    if (state is OffersSuccessState) {
      final currentState = state as OffersSuccessState;
      emit(OffersSuccessState(currentState.offers, currentIndex: index));
    }
  }
}