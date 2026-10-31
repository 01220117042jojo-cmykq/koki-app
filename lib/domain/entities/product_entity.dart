class ProductEntity {
  final int id;

  final String title;

  final String description;

  final double price;
  final double discountPercentage;
  final String thumbnail;

  final List<String> images;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.discountPercentage,
  });

  bool get onSale => discountPercentage > 0;

  double get oldPrice {
    if (onSale) {
      return price / (1 - (discountPercentage / 100));
    }
    return price.toDouble();
  }
}
