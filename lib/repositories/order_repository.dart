// repositories/order_repository.dart
import '../../model/Order/previous_order_model.dart';
import '../services/Order/order_api_service.dart';

class OrderRepository {
  final OrderApiService _apiService;

  OrderRepository({OrderApiService? apiService})
    : _apiService = apiService ?? OrderApiService();

  Future<List<Order>> getOrders() async {
    try {
      return await _apiService.getOrders();
    } catch (e) {
      rethrow; // Let the UI handle this
    }
  }

  Future<bool> reorder(String orderId) async {
    try {
      return await _apiService.reorder(orderId);
    } catch (e) {
      rethrow;
    }
  }
  // repositories/order_repository.dart
  // Add this method to your existing OrderRepository class

  Future<Order> getOrderDetails(String orderId) async {
    try {
      return await _apiService.getOrderDetails(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
