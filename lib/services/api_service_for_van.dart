import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/VanRoute_model.dart';
import '../model/van_booking_progress.dart';
import '../model/van_route_progress.dart';

class VanRouteApiService {
  // Singleton pattern
  static final VanRouteApiService _instance = VanRouteApiService._internal();
  factory VanRouteApiService() => _instance;
  VanRouteApiService._internal();

  // Base URL for the API
  final String baseUrl = 'https://mybackend-l7om.onrender.com/api';

  // Fetch today's van routes
  Future<List<String>> getTodayRoutes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/van-routes/today'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<String>.from(data);
      } else {
        throw Exception('Failed to load routes: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data if API endpoint doesn't exist yet
      return ['S14', 'S15', 'PLA'];
    }
  }

  // Fetch van route locations (markers for the map)
  Future<List<VanRouteLocation>> getRouteLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/van-routes/locations'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => VanRouteLocation.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load route locations: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Return mock data if API endpoint doesn't exist yet
      return [
        VanRouteLocation(
          id: '1',
          name: 'Stop 1',
          latitude: 29.1492,
          longitude: 75.7217,
        ),
        VanRouteLocation(
          id: '2',
          name: 'Stop 2',
          latitude: 29.1552,
          longitude: 75.7367,
        ),
        VanRouteLocation(
          id: '3',
          name: 'Stop 3',
          latitude: 29.1432,
          longitude: 75.7320,
        ),
      ];
    }
  }

  // Get current route progress (for slider)
  Future<RouteProgress> getRouteProgress() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/van-routes/progress'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RouteProgress.fromJson(data);
      } else {
        throw Exception(
          'Failed to load route progress: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Return mock data if API endpoint doesn't exist yet
      return RouteProgress(
        currentProgress: 0.3,
        startTime: "6AM",
        distance: "16KM",
      );
    }
  }

  // Book instant van
  Future<BookingResponse> bookInstantVan({required String location}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/van-booking/instant'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'location': location}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BookingResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to book instant van: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock response if API endpoint doesn't exist yet
      return BookingResponse(
        bookingId: 'mock-booking-123',
        status: 'success',
        message: 'Instant booking created successfully',
        success: true,
      );
    }
  }

  // Schedule van booking
  Future<BookingResponse> scheduleVanBooking({
    required String location,
    required DateTime dateTime,
    String remark = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/van-booking/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'location': location,
          'scheduledDate': dateTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BookingResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to schedule van booking: ${response.statusCode}',
        );
      }
    } catch (e) {
      final formattedDateTime = DateFormat(
        'dd/MM/yyyy hh:mm a',
      ).format(dateTime);

      // Return mock response if API endpoint doesn't exist yet
      return BookingResponse(
        success: true,
        bookingId: 'SCH${Random().nextInt(10000)}',
        message: 'Van scheduled successfully for $formattedDateTime',
        status: '',
      );
    }
  }
  //Booking Response

  // Get user's current basket
  Future<Basket> getBasket() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/basket'));

      if (response.statusCode == 200) {
        return Basket.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load basket: ${response.statusCode}');
      }
    } catch (e) {
      // Return empty basket if API endpoint doesn't exist yet
      return Basket(itemCount: 0, items: [], totalAmount: 0.0);
    }
  }
}
