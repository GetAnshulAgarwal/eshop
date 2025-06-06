import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../screen/ProfileSubScreen/saved_address_screen.dart';

class MockApiService {
  // Singleton pattern
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();
  Future<List<Address>> getAddresses() async {
    // Load the JSON from assets
    final jsonString = await rootBundle.loadString(
      'assets/data/address_data.json',
    );
    final jsonData = json.decode(jsonString) as List;

    return jsonData.map((item) => Address.fromJson(item)).toList();
  }

  // Mock categories data
  Future<List<Category>> fetchCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      Category(id: '1', name: 'Dry Fruit', image: 'assets/images/banana.png'),
      Category(id: '2', name: 'Fruits', image: 'assets/images/banana.png'),
      Category(id: '3', name: 'Vegetables', image: 'assets/images/veg.png'),
      Category(id: '4', name: 'Dairy', image: 'assets/images/banana.png'),
      Category(id: '5', name: 'Bakery', image: 'assets/images/banana.png'),
    ];
  }

  // Mock products data by category
  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
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
      case 'Dairy':
        products = [
          Product(
            id: '12',
            name: 'Milk',
            price: 3.99,
            image: 'assets/images/banana.png',
            category: 'Dairy',
            description: 'Organic Whole Milk',
          ),
          Product(
            id: '13',
            name: 'Cheese',
            price: 5.49,
            image: 'assets/images/banana.png',
            category: 'Dairy',
            description: 'Cheddar Cheese',
          ),
          Product(
            id: '14',
            name: 'Yogurt',
            price: 2.99,
            image: 'assets/images/banana.png',
            category: 'Dairy',
            description: 'Greek Yogurt',
          ),
        ];
        break;
      case 'Bakery':
        products = [
          Product(
            id: '15',
            name: 'Bread',
            price: 3.49,
            image: 'assets/images/banana.png',
            category: 'Bakery',
            description: 'Whole Wheat Bread',
          ),
          Product(
            id: '16',
            name: 'Croissant',
            price: 2.99,
            image: 'assets/images/banana.png',
            category: 'Bakery',
            description: 'Butter Croissant',
          ),
          Product(
            id: '17',
            name: 'Muffin',
            price: 1.99,
            image: 'assets/images/banana.png',
            category: 'Bakery',
            description: 'Blueberry Muffin',
          ),
        ];
        break;
      default:
        products = [
          Product(
            id: '18',
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
