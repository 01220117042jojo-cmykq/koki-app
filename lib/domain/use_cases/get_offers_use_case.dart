import 'package:koki/domain/entities/offer_entity.dart';
import 'package:koki/domain/repository/products_repository.dart';

class GetOffersUseCase {
  final ProductsRepository repository;

  GetOffersUseCase({required this.repository});

  Future<List<OfferEntity>> call() async {
    return await repository.getOffers();
  }
}
