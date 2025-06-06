class ReturnStatus {
  final String status;
  final String date;
  final String time;
  final bool isCompleted;

  ReturnStatus({
    required this.status,
    required this.date,
    required this.time,
    required this.isCompleted,
  });

  factory ReturnStatus.fromJson(Map<String, dynamic> json) {
    return ReturnStatus(
      status: json['status'],
      date: json['date'],
      time: json['time'],
      isCompleted: json['is_completed'],
    );
  }
}

// Add this model for returned items
class ReturnedItem {
  final String productName;
  final String weight;
  final double price;
  final int quantity;
  final String image;

  ReturnedItem({
    required this.productName,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory ReturnedItem.fromJson(Map<String, dynamic> json) {
    return ReturnedItem(
      productName: json['product_name'],
      weight: json['weight'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      image: json['image'],
    );
  }
}

// Add this model to track returns
class ReturnInfo {
  final double returnAmount;
  final String currency;
  final List<ReturnedItem> items;
  final List<ReturnStatus> statusUpdates;
  final String referenceNumber;

  ReturnInfo({
    required this.returnAmount,
    required this.currency,
    required this.items,
    required this.statusUpdates,
    required this.referenceNumber,
  });

  factory ReturnInfo.fromJson(Map<String, dynamic> json) {
    return ReturnInfo(
      returnAmount: json['return_amount'].toDouble(),
      currency: json['currency'],
      items:
          (json['items'] as List)
              .map((item) => ReturnedItem.fromJson(item))
              .toList(),
      statusUpdates:
          (json['status_updates'] as List)
              .map((status) => ReturnStatus.fromJson(status))
              .toList(),
      referenceNumber: json['reference_number'],
    );
  }
}
