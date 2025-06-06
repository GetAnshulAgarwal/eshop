import '../Return/return_model.dart';

class OrderDeliveryDetails {
  final String recipientName;
  final String deliveryPersonName;
  final String partnerType;
  final String deliveryType;
  final String deliveryAddress;

  OrderDeliveryDetails({
    required this.recipientName,
    required this.deliveryPersonName,
    required this.partnerType,
    required this.deliveryType,
    required this.deliveryAddress,
  });

  factory OrderDeliveryDetails.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryDetails(
      recipientName: json['recipient_name'],
      deliveryPersonName: json['delivery_person_name'],
      partnerType: json['partner_type'],
      deliveryType: json['delivery_type'],
      deliveryAddress: json['delivery_address'],
    );
  }
}

class OrderItem {
  final String productName;
  final String weight;
  final double price;
  final int quantity;
  final String image;

  OrderItem({
    required this.productName,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['product_name'],
      weight: json['weight'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      image: json['image'],
    );
  }
}

class OrderBilling {
  final double itemsTotal;
  final double deliveryCharge;
  final double platformCharges;
  final double cartCharges;
  final double tip;
  final double grandTotal;

  OrderBilling({
    required this.itemsTotal,
    required this.deliveryCharge,
    required this.platformCharges,
    required this.cartCharges,
    required this.tip,
    required this.grandTotal,
  });

  factory OrderBilling.fromJson(Map<String, dynamic> json) {
    return OrderBilling(
      itemsTotal: json['items_total'].toDouble(),
      deliveryCharge: json['delivery_charge'].toDouble(),
      platformCharges: json['platform_charges'].toDouble(),
      cartCharges: json['cart_charges'].toDouble(),
      tip: json['tip'].toDouble(),
      grandTotal: json['grand_total'].toDouble(),
    );
  }
}

class Order {
  final String id;
  final String invoiceNumber;
  final double amount;
  final DateTime date;
  final String orderType;
  final List<String> productImages;
  List<OrderItem>? items; // Can be null initially
  OrderBilling? billing; // Can be null initially
  OrderDeliveryDetails? deliveryDetails; //New field for delivery details
  ReturnInfo? returnInfo; // Add the return info field

  Order({
    required this.id,
    required this.invoiceNumber,
    required this.amount,
    required this.date,
    required this.orderType,
    required this.productImages,
    this.items,
    this.billing,
    this.deliveryDetails,
    this.returnInfo, // Add to constructor
  });

  bool isValid() {
    if (items != null && productImages.length != items!.length) {
      print(
        'Warning: Number of product images (${productImages.length}) does not match number of items (${items!.length})',
      );
      return false;
    }
    return true;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      orderType: json['order_type'],
      productImages: List<String>.from(json['product_images']),
      items:
          json['items'] != null
              ? (json['items'] as List)
                  .map((item) => OrderItem.fromJson(item))
                  .toList()
              : null,
      billing:
          json['billing'] != null
              ? OrderBilling.fromJson(json['billing'])
              : null,
      deliveryDetails:
          json['delivery_details'] != null
              ? OrderDeliveryDetails.fromJson(json['delivery_details'])
              : null,
      returnInfo:
          json['return_info'] != null
              ? ReturnInfo.fromJson(json['return_info'])
              : null,
    );
  }
}
