class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['imageUrl'] ?? json['image'] ?? '',
      price: _parsePrice(json['price']),

      category: json['category'] ?? '',

      description: json['description'] ?? '',
    );
  }
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      try {
        return double.parse(price);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': image,
      'price': price,
      'category': category,

      'description': description,
    };
  }
}
