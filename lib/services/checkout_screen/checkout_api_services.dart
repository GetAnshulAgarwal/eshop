// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/checkout/product_model.dart';

class ApiService {
  final String baseUrl = 'https://your-api-endpoint.com/api';

  // Fetch cart items from API
  Future<List<Produc>> getCartItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Produc.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cart items: ${response.statusCode}');
      }
    } catch (e) {
      // For demo/testing purposes, return mock data if API fails
      return _getMockCartItems();
    }
  }

  // Fetch recommended products
  Future<List<RecommendedProduct>> getRecommendedProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recommendations'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => RecommendedProduct.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (e) {
      // Return mock data for demo
      return _getMockRecommendations();
    }
  }

  // Update cart item quantity - FIX: Convert productId to string
  Future<bool> updateCartItemQuantity(int productId, int quantity) async {
    try {
      // Fix: Convert the integer productId to a string
      final response = await http.put(
        Uri.parse('$baseUrl/cart/${productId.toString()}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'quantity': quantity}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating quantity: $e');
      return true; // Return true for demo purposes
    }
  }

  // Mock data for cart items
  List<Produc> _getMockCartItems() {
    return [
      Produc(
        id: 1,
        name: 'Product Name',
        image: 'assets/strawberry.png',
        price: 44.0,
        weight: '',
      ),
      Produc(
        id: 2,
        name: 'Product Name',
        image: 'assets/strawberry.png',
        weight: '200 g',
        price: 44.0,
      ),
      Produc(
        id: 3,
        name: 'Product Name',
        image: 'assets/strawberry.png',
        weight: '200 g',
        price: 40,
      ),
    ];
  }

  // Mock data for recommendations
  List<RecommendedProduct> _getMockRecommendations() {
    return [
      RecommendedProduct(
        id: 1,
        title: 'Golden Mango Twist',
        subtitle: 'Mixed Mango',
        image: 'assets/mango_tart.png',
        price: 120.0,
      ),
      RecommendedProduct(
        id: 2,
        title: 'Fruit Mango Tart',
        subtitle: 'Pineapple, Strawberry',
        image: 'assets/fruit_tart.png',
        price: 150.0,
      ),
      RecommendedProduct(
        id: 3,
        title: 'Golden Mango Twist',
        subtitle: 'Mixed Mango',
        image: 'assets/mango_tart.png',
        price: 120.0,
      ),
    ];
  }
}
