import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../screen/ProfileSubScreen/saved_address_screen.dart';

class ApiService {
  static const String baseUrl = 'your-api-base-url';

  // Get wallet transactions
  static Future<Map<String, dynamic>> getTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // Get saved addresses
  static Future<List<dynamic>> getAddresses() async {
    final response = await http.get(Uri.parse('$baseUrl/addresses'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load addresses');
    }
  }

  // Save address
  static Future<Address> saveAddress(Address address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addresses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullAddress': address.fullAddress,
        'label': address.label,
        'type': address.type.toString().split('.').last,
        'latitude': address.latitude,
        'longitude': address.longitude,
      }),
    );

    if (response.statusCode == 201) {
      return Address.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save address');
    }
  }
}
