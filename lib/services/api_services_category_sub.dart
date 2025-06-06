import 'dart:async';
import '../model/category_model.dart';
import '../model/product_model.dart';

class ApiService {
  // Mock categories data
  Future<Map<String, dynamic>> fetchData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    List<Category> categories = [
      Category(id: '1', name: 'Dry Fruit', image: 'assets/images/banana.png'),
      Category(id: '2', name: 'Fruits', image: 'assets/images/banana.png'),
      Category(id: '3', name: 'Vegetables', image: 'assets/images/veg.png'),
      Category(id: '4', name: 'Dairy', image: 'assets/images/banana.png'),
      Category(id: '5', name: 'Bakery', image: 'assets/images/banana.png'),
    ];

    // Get products for the first category as default
    List<Product> products = await _getProductsByCategory(categories[0].name);

    return {'categories': categories, 'products': products};
  }

  Future<List<Product>> _getProductsByCategory(String categoryName) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Base products with different data based on category
    List<Product> products = [];

    switch (categoryName) {
      case 'Dry Fruit':
        products = [
          Product(
            id: '1',
            name: 'Almonds',
            price: 12.99,
            image: 'assets/images/banana.png',
            category: 'Dry Fruit',
            description: 'Fresh California Almonds',
          ),
          Product(
            id: '2',
            name: 'Cashews',
            price: 14.99,
            image: 'assets/images/banana.png',
            category: 'Dry Fruit',
            description: 'Premium Cashew Nuts',
          ),
          Product(
            id: '3',
            name: 'Walnuts',
            price: 9.99,
            image: 'assets/images/banana.png',
            category: 'Dry Fruit',
            description: 'Organic Walnuts',
          ),
          Product(
            id: '4',
            name: 'Pistachios',
            price: 16.99,
            image: 'assets/images/banana.png',
            category: 'Dry Fruit',
            description: 'Roasted & Salted Pistachios',
          ),
          Product(
            id: '5',
            name: 'Raisins',
            price: 5.99,
            image: 'assets/images/banana.png',
            category: 'Dry Fruit',
            description: 'Seedless Golden Raisins',
          ),
        ];
        break;
      case 'Fruits':
        products = [
          Product(
            id: '6',
            name: 'Apple',
            price: 2.99,
            image: 'assets/images/banana.png',
            category: 'Fruits',
            description: 'Fresh Red Apples',
          ),
          Product(
            id: '7',
            name: 'Banana',
            price: 1.49,
            image: 'assets/images/banana.png',
            category: 'Fruits',
            description: 'Organic Bananas',
          ),
          Product(
            id: '8',
            name: 'Orange',
            price: 3.49,
            image: 'assets/images/banana.png',
            category: 'Fruits',
            description: 'Sweet Navel Oranges',
          ),
        ];
        break;
      case 'Vegetables':
        products = [
          Product(
            id: '9',
            name: 'Carrots',
            price: 1.99,
            image: 'assets/images/veg.png',
            category: 'Vegetables',
            description: 'Organic Carrots',
          ),
          Product(
            id: '10',
            name: 'Broccoli',
            price: 2.49,
            image: 'assets/images/veg.png',
            category: 'Vegetables',
            description: 'Fresh Broccoli',
          ),
          Product(
            id: '11',
            name: 'Spinach',
            price: 3.99,
            image: 'assets/images/veg.png',
            category: 'Vegetables',
            description: 'Baby Spinach',
          ),
        ];
        break;
      default:
        products = [
          Product(
            id: '12',
            name: 'Sample Product',
            price: 9.99,
            image: 'assets/images/banana.png',
            category: categoryName,
            description: 'Sample Product Description',
          ),
        ];
    }

    return products;
  }
}
