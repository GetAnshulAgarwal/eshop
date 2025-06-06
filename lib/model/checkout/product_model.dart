// lib/models/product.dart
class Produc {
  final int id;
  final String name;
  final String image;
  final String weight;
  final double price;
  int quantity;

  Produc({
    required this.id,
    required this.name,
    required this.image,
    required this.weight,
    required this.price,
    this.quantity = 1,
  });

  factory Produc.fromJson(Map<String, dynamic> json) {
    return Produc(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      weight: json['weight'],
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'weight': weight,
      'price': price,
      'quantity': quantity,
    };
  }

  double get totalPrice => price * quantity;
}

class RecommendedProduct {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final double price;

  RecommendedProduct({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
  });

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) {
    return RecommendedProduct(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }
}
