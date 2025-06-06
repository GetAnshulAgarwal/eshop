// screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/Order/previous_order_model.dart';
import '../../repositories/order_repository.dart';
import '../../services/Order/order_api_service.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderRepository _repository = OrderRepository();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _ordersFuture = _repository.getOrders();
    });
  }

  Future<void> _handleRefresh() async {
    _loadOrders();
    // Wait for the future to complete
    await _ordersFuture;
    return;
  }

  Future<void> _reorder(Order order) async {
    try {
      final success = await _repository.reorder(order.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully reordered ${order.invoiceNumber}'),
          ),
        );
      }
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Orders',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Using the correct return type function
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Failed to load orders',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadOrders,
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            final orders = snapshot.data!;

            if (orders.isEmpty) {
              return Center(
                child: Text('No orders found', style: TextStyle(fontSize: 16)),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: OrderCard(
                    order: order,
                    onReorder: () => _reorder(order),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onReorder;

  const OrderCard({super.key, required this.order, required this.onReorder});

  Color _getOrderTypeColor() {
    return order.orderType == 'Van Order'
        ? Color(0xFFFFE5D9)
        : Color(0xFFFFEFD9);
  }

  Color _getOrderTypeTextColor() {
    return order.orderType == 'Van Order'
        ? Color(0xFFFF6B35)
        : Color(0xFFFFA726);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final formattedDate = dateFormat.format(order.date);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(orderId: order.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.invoiceNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${order.amount.toStringAsFixed(2)} • $formattedDate',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getOrderTypeColor(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order.orderType,
                    style: TextStyle(
                      color: _getOrderTypeTextColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children:
                      order.productImages
                          .map(
                            (productImage) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                productImage,
                                width: 40,
                                height: 40,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.red[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.local_offer,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                TextButton(
                  onPressed: onReorder,
                  child: Text(
                    'RE-ORDER',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
