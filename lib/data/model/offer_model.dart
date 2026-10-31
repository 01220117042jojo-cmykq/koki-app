import 'package:koki/domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  OfferModel({
    required super.id,
    required super.imageUrl,
    required super.title,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'imageUrl': imageUrl, 'title': title};
  }
}
