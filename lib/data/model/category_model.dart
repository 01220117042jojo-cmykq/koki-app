import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  final String url ;
  CategoryModel({
    required super.slug,
    required super.name,
    required this.url,
});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String , dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'url': url,
    };
  }
}