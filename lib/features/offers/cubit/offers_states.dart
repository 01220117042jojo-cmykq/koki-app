import '../../../domain/entities/offer_entity.dart';

abstract class OffersStates {}

class OffersInitialState extends OffersStates {}

class OffersLoadingState extends OffersStates {}

class OffersSuccessState extends OffersStates {
  final List<OfferEntity> offers;
  final int currentIndex;

  OffersSuccessState(this.offers, {this.currentIndex = 0});
}

class OffersErrorState extends OffersStates {
  final String errorMessage;

  OffersErrorState(this.errorMessage);
}
