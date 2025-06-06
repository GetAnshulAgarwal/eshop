class BookingResponse {
  final String bookingId;
  final String status;
  final String message;
  final bool success;

  BookingResponse({
    required this.bookingId,
    required this.status,
    required this.message,
    required this.success,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookingId: json['bookingId'] ?? '',
      status: json['status'] ?? 'pending',
      message: json['message'] ?? 'No message provided',
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'bookingId': bookingId, 'status': status, 'message': message};
  }

  @override
  String toString() {
    return 'BookingResponse{bookingId: $bookingId, status: $status, message: $message}';
  }
}

class BookingStatus {
  final String bookingId;
  final String status;
  final DateTime estimatedArrival;
  final String driverName;
  final String driverPhone;
  final String vehicleNumber;

  BookingStatus({
    required this.bookingId,
    required this.status,
    required this.estimatedArrival,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleNumber,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) {
    return BookingStatus(
      bookingId: json['bookingId'] ?? '',
      status: json['status'] ?? 'pending',
      estimatedArrival:
          DateTime.tryParse(json['estimatedArrival'] ?? '') ??
          DateTime.now().add(const Duration(minutes: 30)),
      driverName: json['driverName'] ?? 'Not assigned',
      driverPhone: json['driverPhone'] ?? 'Not available',
      vehicleNumber: json['vehicleNumber'] ?? 'Not assigned',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'status': status,
      'estimatedArrival': estimatedArrival.toIso8601String(),
      'driverName': driverName,
      'driverPhone': driverPhone,
      'vehicleNumber': vehicleNumber,
    };
  }

  @override
  String toString() {
    return 'BookingStatus{bookingId: $bookingId, status: $status, '
        'estimatedArrival: $estimatedArrival, driverName: $driverName, '
        'driverPhone: $driverPhone, vehicleNumber: $vehicleNumber}';
  }
}

class BasketItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? image;

  BasketItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.image,
  });

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Item',
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      if (image != null) 'image': image,
    };
  }

  double get totalPrice => price * quantity;

  @override
  String toString() {
    return 'BasketItem{id: $id, name: $name, quantity: $quantity, price: $price}';
  }
}

class Basket {
  final int itemCount;
  final List<BasketItem> items;
  final double totalAmount;

  Basket({
    required this.itemCount,
    required this.items,
    required this.totalAmount,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      itemCount: json['itemCount'] ?? 0,
      items:
          ((json['items'] as List?) ?? [])
              .map((item) => BasketItem.fromJson(item))
              .toList(),
      totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemCount': itemCount,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
    };
  }

  // Factory method to create an empty basket
  factory Basket.empty() {
    return Basket(itemCount: 0, items: [], totalAmount: 0.0);
  }

  @override
  String toString() {
    return 'Basket{itemCount: $itemCount, totalAmount: $totalAmount, items: $items}';
  }
}
