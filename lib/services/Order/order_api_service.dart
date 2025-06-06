// services/order_api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../../model/Order/previous_order_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class OrderApiService {
  // Simulate network delay
  final int _mockDelay = 800; // milliseconds

  // Mock data
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': '1001',
      'invoice_number': 'INV-2023-001',
      'amount': 23.50,
      'date': '2023-04-30T10:30:00Z',
      'order_type': 'Van Order',
      'product_images': ['assets/veg.png', 'assets/veg.png', 'assets/veg.png'],
    },
    {
      'id': '1002',
      'invoice_number': 'INV-2023-002',
      'amount': 18.75,
      'date': '2023-04-30T14:15:00Z',
      'order_type': 'Rider Order',
      'product_images': ['assets/veg.png', 'assets/veg.png', 'assets/veg.png'],
    },
    {
      'id': '1003',
      'invoice_number': 'INV-2023-003',
      'amount': 42.30,
      'date': '2023-04-29T09:45:00Z',
      'order_type': 'Van Order',
      'product_images': ['assets/images/veg.png', 'assets/images/veg.png'],
    },
    {
      'id': '1004',
      'invoice_number': 'INV-2023-004',
      'amount': 31.20,
      'date': '2023-04-28T16:50:00Z',
      'order_type': 'Rider Order',
      'product_images': [
        'assets/images/veg.png',
        'assets/images/veg.png',
        'assets/images/veg.png',
        'assets/images/veg.png',
      ],
    },
  ];

  // services/order_api_service.dart

  // Define some realistic delivery details for each order:
  final List<Map<String, dynamic>> _deliveryDetails = [
    {
      'recipient_name': 'Rahul Singh',
      'delivery_person_name': 'Sandeep Kumar',
      'partner_type': 'VAN Partner',
      'delivery_type': 'Scheduled',
      'delivery_address':
          'Singh Home, House Number 223/23, Hisar Chungi, Arya Nagar, Hansi - 125033, Haryana, India.',
    },
    {
      'recipient_name': 'Priya Sharma',
      'delivery_person_name': 'Vikram Patel',
      'partner_type': 'VAN Partner',
      'delivery_type': 'Express',
      'delivery_address':
          '42, Lake View Apartments, MG Road, Bangalore - 560001, Karnataka, India.',
    },
    {
      'recipient_name': 'Amit Verma',
      'delivery_person_name': 'Rajesh Gupta',
      'partner_type': 'Rider',
      'delivery_type': 'Same Day',
      'delivery_address':
          'Flat 303, Sunshine Towers, Sector 15, Noida - 201301, Uttar Pradesh, India.',
    },
    {
      'recipient_name': 'Neha Kapoor',
      'delivery_person_name': 'Manoj Tiwari',
      'partner_type': 'Rider',
      'delivery_type': 'Scheduled',
      'delivery_address':
          '78B, Green Park Extension, New Delhi - 110016, India.',
    },
  ];

  // Update the getOrderDetails method to include delivery details
  Future<Order> getOrderDetails(String id) async {
    await Future.delayed(Duration(milliseconds: _mockDelay));

    // Find the order index in our mock data
    final orderIndex = _mockOrders.indexWhere((order) => order['id'] == id);

    if (orderIndex == -1) {
      throw ApiException('Order not found');
    }

    // Get the order JSON
    final orderJson = Map<String, dynamic>.from(_mockOrders[orderIndex]);

    // Generate unique items based on the order's product_images
    final productImages = orderJson['product_images'] as List;
    final items = [];

    for (int i = 0; i < productImages.length; i++) {
      items.add({
        'product_name': 'Product ${i + 1}',
        'weight': '${200 + (i * 50)} g',
        'price': (orderJson['amount'] / productImages.length).toDouble(),
        'quantity': 1,
        'image': productImages[i],
      });
    }

    orderJson['items'] = items;

    // Calculate billing based on actual items
    final itemsTotal = (orderJson['amount']).toDouble();
    final deliveryCharge = 2.50;
    final platformCharges = 1.00;
    final cartCharges = 0.50;
    final tip = 2.00;
    final grandTotal =
        itemsTotal + deliveryCharge + platformCharges + cartCharges + tip;

    // Add billing data
    orderJson['billing'] = {
      'items_total': itemsTotal,
      'delivery_charge': deliveryCharge,
      'platform_charges': platformCharges,
      'cart_charges': cartCharges,
      'tip': tip,
      'grand_total': grandTotal,
    };

    // Add delivery details - get details that match the order's position or default to first
    final deliveryDetailsIndex =
        orderIndex < _deliveryDetails.length ? orderIndex : 0;

    // Add delivery details that match the order type
    Map<String, dynamic> details = Map<String, dynamic>.from(
      _deliveryDetails[deliveryDetailsIndex],
    );

    // Update partner type based on order type
    if (orderJson['order_type'] == 'Van Order') {
      details['partner_type'] = 'VAN Partner';
    } else {
      details['partner_type'] = 'Rider';
    }

    orderJson['delivery_details'] = details;

    if (id == "101" || id == "103") {
      print("Adding return info to order $id");

      // Choose one item from the order to be returned
      final returnedItem = items[0];

      orderJson['return_info'] = {
        'return_amount': returnedItem['price'] * returnedItem['quantity'],
        'currency': '£',
        'items': [returnedItem],
        'status_updates': [
          {
            'status': 'Return Completed',
            'date': '18 Jan, 2024',
            'time': '11:11 am',
            'is_completed': true,
          },
          {
            'status': 'Return initiated',
            'date': '15 Jan, 2024',
            'time': '11:11 am',
            'is_completed': true,
          },
          {'status': 'Picked up', 'date': '16 Jan, 2024', 'is_completed': true},
        ],
      };
    }

    return Order.fromJson(orderJson);
  }

  // Get all orders with simulated API delay
  Future<List<Order>> getOrders() async {
    // Simulate network request
    await Future.delayed(Duration(milliseconds: _mockDelay));

    // Simulate occasional failure
    if (Random().nextInt(10) == 0) {
      throw ApiException('Failed to fetch orders. Please try again.');
    }

    return _mockOrders.map((json) => Order.fromJson(json)).toList();
  }

  // Get order by ID
  Future<Order> getOrderById(String id) async {
    await Future.delayed(Duration(milliseconds: _mockDelay));

    final orderJson = _mockOrders.firstWhere(
      (order) => order['id'] == id,
      orElse: () => throw ApiException('Order not found'),
    );

    return Order.fromJson(orderJson);
  }

  // Simulate reordering functionality
  Future<bool> reorder(String orderId) async {
    await Future.delayed(Duration(milliseconds: _mockDelay));

    // Find order to verify it exists
    try {
      await getOrderById(orderId);
      // Order found, reorder successful
      return true;
    } catch (e) {
      throw ApiException('Failed to reorder. Order not found.');
    }
  }
}
