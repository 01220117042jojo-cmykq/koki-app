import 'package:koki/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.thumbnail,
    required super.images,
    required super.discountPercentage,
  });

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      discountPercentage:
      (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] as String? ?? '',
      images: json['images'] != null ? json['images'].cast<String>() : [],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['price'] = price;
    map['discountPercentage']= discountPercentage;
    map['thumbnail'] = thumbnail;
    map['images'] = images;
    return map;
  }
}
