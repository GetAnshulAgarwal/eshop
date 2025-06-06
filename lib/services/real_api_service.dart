import '../model/category_model.dart';
import '../model/product_model.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';

class RealApiService {
  // Singleton pattern
  static final RealApiService _instance = RealApiService._internal();
  factory RealApiService() => _instance;
  RealApiService._internal();

  // Base URL for the API
  final String baseUrl = 'https://mybackend-l7om.onrender.com/api';

  // Fetch all categories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Create a new category
  Future<Category> createCategory(Category category) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 201) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Upload category image
  Future<String> uploadCategoryImage(String categoryId, File imageFile) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/categories/upload-images'),
      );

      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: path.basename(imageFile.path),
        ),
      );

      // Add category ID to request
      request.fields['categoryId'] = categoryId;

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['imageUrl'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Get category by ID
  Future<Category> getCategoryById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories/$id'));

      if (response.statusCode == 200) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  // Update category
  Future<Category> updateCategory(String id, Category category) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 200) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/categories/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  // Fetch products by category name - This is a workaround since the API doesn't explicitly show this endpoint
  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    try {
      // First get the category ID by name
      final categoriesResponse = await http.get(
        Uri.parse('$baseUrl/categories'),
      );

      if (categoriesResponse.statusCode != 200) {
        throw Exception(
          'Failed to load categories: ${categoriesResponse.statusCode}',
        );
      }

      final List<dynamic> categoriesData = json.decode(categoriesResponse.body);
      final categories =
          categoriesData.map((json) => Category.fromJson(json)).toList();

      // Find the category ID by name
      final category = categories.firstWhere(
        (c) => c.name == categoryName,
        orElse: () => throw Exception('Category not found: $categoryName'),
      );

      // Now fetch products for this category ID
      // This endpoint is assumed - you'll need to adjust based on actual API structure
      final productsResponse = await http.get(
        Uri.parse('$baseUrl/categories/${category.id}/products'),
      );

      if (productsResponse.statusCode == 200) {
        final List<dynamic> data = json.decode(productsResponse.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load products: ${productsResponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Methods for working with subcategories
  Future<List<dynamic>> fetchSubcategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/subcategories'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load subcategories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  // Upload subcategory image
  Future<String> uploadSubcategoryImage(
    String subcategoryId,
    File imageFile,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/subcategories/upload-images'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: path.basename(imageFile.path),
        ),
      );

      request.fields['subcategoryId'] = subcategoryId;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['imageUrl'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
