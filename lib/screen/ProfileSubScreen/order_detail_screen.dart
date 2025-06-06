// screens/order_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../model/Order/previous_order_model.dart';
import '../../repositories/order_repository.dart';
import '../../services/Order/order_api_service.dart';
import '../../screen/ProfileSubScreen/help_and_support_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderRepository _repository = OrderRepository();
  late Future<Order> _orderDetailsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // For debugging purposes, log the order ID being displayed
    print('Loading details for Order ID: ${widget.orderId}');
  }

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  void _loadOrderDetails() {
    setState(() {
      _orderDetailsFuture = _repository.getOrderDetails(widget.orderId);
    });
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

  void _downloadInvoice(Order order) {
    // In a real app, this would handle the download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading invoice for ${order.invoiceNumber}...'),
      ),
    );
  }

  void _chatWithSupport() {
    // Navigate to support screen or show chat dialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatWithSupport()),
    );
  }

  Widget _buildStatusItem({
    required String status,
    required String date,
    required String time,
    required bool isCompleted,
    required bool showLine,
    Widget? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.red[800] : Colors.grey[400],
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 14),
                ),
                if (showLine)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    width: 2,
                    height: 40,
                    color: Colors.grey[300],
                  ),
              ],
            ),

            SizedBox(width: 12),

            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$date - $time',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (icon != null) icon,
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ],
    );
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
          'Order Summary',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder<Order>(
        future: _orderDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error loading order details: ${snapshot.error}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load order details',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadOrderDetails,
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final order = snapshot.data!;
          final dateFormat = DateFormat('MMMM dd, yyyy');
          final formattedDate = dateFormat.format(order.date);

          // Debug print to see if returnInfo exists
          print("Order has returnInfo: ${order.returnInfo != null}");
          if (order.returnInfo != null) {
            print("Return items count: ${order.returnInfo!.items.length}");
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.invoiceNumber,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dated: $formattedDate',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${order.items?.length ?? 0} items in this order',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Order items
                      if (order.items != null)
                        ...order.items!.map(
                          (item) => OrderItemCard(item: item),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Billing Details
                Text(
                  'Billing Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                if (order.billing != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        BillingRow(
                          title: 'Items total',
                          value:
                              '\$${order.billing!.itemsTotal.toStringAsFixed(2)}',
                          icon: Icons.list_alt,
                        ),
                        BillingRow(
                          title: 'Delivery Charge',
                          value:
                              '\$${order.billing!.deliveryCharge.toStringAsFixed(2)}',
                          icon: Icons.delivery_dining,
                        ),
                        BillingRow(
                          title: 'Platform Charges',
                          value:
                              '\$${order.billing!.platformCharges.toStringAsFixed(2)}',
                          icon: Icons.devices,
                        ),
                        BillingRow(
                          title: 'Cart Charges',
                          value:
                              '\$${order.billing!.cartCharges.toStringAsFixed(2)}',
                          icon: Icons.shopping_cart,
                        ),
                        BillingRow(
                          title: 'Tip for your delivery partner',
                          value: '\$${order.billing!.tip.toStringAsFixed(2)}',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 12),
                        Divider(),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${order.billing!.grandTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 24),

                // Invoice download button
                GestureDetector(
                  onTap: () => _downloadInvoice(order),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Download Invoice',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.download, color: Colors.red[800], size: 18),
                      ],
                    ),
                  ),
                ),

                // Returned Items Section (if any)
                if (order.returnInfo != null &&
                    order.returnInfo!.items.isNotEmpty) ...[
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      '${order.returnInfo!.items.length} item returned',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Returned Items List
                  ...order.returnInfo!.items
                      .map(
                        (item) => Container(
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.red[100],
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.red,
                                              ),
                                            ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        item.weight,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${order.returnInfo!.currency}${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${item.quantity}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),

                  SizedBox(height: 20),

                  // Return Status Section
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
                    child: Text(
                      'Return Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Return amount header with icon
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[100],
                              ),
                              child: Icon(
                                Icons.replay_circle_filled,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Return of ${order.returnInfo!.currency}${order.returnInfo!.returnAmount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Return Completed on 18 Jan, 2024',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        // Horizontal line
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(height: 1, color: Colors.grey[300]),
                        ),

                        SizedBox(height: 10),

                        // Return status timeline
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              // Dynamic status items from API if available
                              if (order.returnInfo!.statusUpdates.isNotEmpty)
                                ...order.returnInfo!.statusUpdates
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final status = entry.value;
                                      final isLast =
                                          index ==
                                          order
                                                  .returnInfo!
                                                  .statusUpdates
                                                  .length -
                                              1;

                                      // Special case for "Picked up" status to show item image
                                      Widget? statusIcon;
                                      if (status.status.toLowerCase().contains(
                                        'picked up',
                                      )) {
                                        statusIcon = Padding(
                                          padding: EdgeInsets.only(
                                            left: 12,
                                            top: 4,
                                          ),
                                          child: Image.asset(
                                            'assets/images/strawberry.png',
                                            width: 24,
                                            height: 24,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.shopping_basket,
                                                      size: 24,
                                                      color: Colors.red[300],
                                                    ),
                                          ),
                                        );
                                      }

                                      return _buildStatusItem(
                                        status: status.status,
                                        date: status.date,
                                        time: status.time,
                                        isCompleted: status.isCompleted,
                                        showLine: !isLast,
                                        icon: statusIcon,
                                      );
                                    })
                                    .toList()
                              // Fallback to static items if no status updates in
                              else ...[
                                // Return initiated
                                _buildStatusItem(
                                  status: 'Return initiated for 310',
                                  date: '13 Jan, 2024',
                                  time: '11:11 am',
                                  isCompleted: true,
                                  showLine: true,
                                ),

                                // Picked up
                                _buildStatusItem(
                                  status: 'Picked up',
                                  date: '13 Jan, 2024',
                                  time: '12:11 am',
                                  isCompleted: true,
                                  showLine: true,
                                  icon: Padding(
                                    padding: EdgeInsets.only(left: 12, top: 4),
                                    child: Image.asset(
                                      'assets/images/strawberry.png',
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.shopping_basket,
                                            size: 24,
                                            color: Colors.red[300],
                                          ),
                                    ),
                                  ),
                                ),

                                // Return Processed
                                _buildStatusItem(
                                  status: 'Return Processed',
                                  date: '13 Jan, 2024',
                                  time: '1:11 am',
                                  isCompleted: true,
                                  showLine: true,
                                ),

                                // Return Complete
                                _buildStatusItem(
                                  status: 'Return Complete',
                                  date: '13 Jan, 2024',
                                  time: '1:21 am',
                                  isCompleted: true,
                                  showLine: false,
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // Return reference number
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Return reference number (RRN):',
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    order.returnInfo!.referenceNumber,
                                    style: TextStyle(
                                      color: Colors.red[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: order.returnInfo!.referenceNumber,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Reference number copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red[200]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.red[800],
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 24),

                // Order Details section
                Text(
                  'Order Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailRow(title: 'Order Id', value: 'GOWAPP${order.id}'),
                      DetailRow(
                        title: 'Delivered To',
                        value:
                            order.deliveryDetails?.recipientName ??
                            'Not available',
                      ),
                      DetailRow(
                        title: 'Delivered By',
                        value:
                            order.deliveryDetails?.deliveryPersonName ??
                            'Not available',
                      ),
                      DetailRow(
                        title: 'Partner Type',
                        value:
                            order.deliveryDetails?.partnerType ??
                            order.orderType,
                      ),
                      DetailRow(
                        title: 'Delivery Type',
                        value:
                            order.deliveryDetails?.deliveryType ?? 'Standard',
                      ),
                      DetailRow(
                        title: 'Delivery Address',
                        value:
                            order.deliveryDetails?.deliveryAddress ??
                            'Address not available',
                        isMultiLine: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Help & Support section
                Text(
                  'Help & Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                GestureDetector(
                  onTap: _chatWithSupport,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_outlined,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Chat with Us',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Put this at the end, after all sections
                SizedBox(height: 24),

                // Reorder button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _reorder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Re Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderItem item;

  const OrderItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(
              item.image,
              width: 50,
              height: 50,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_offer, color: Colors.red, size: 24),
                  ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.weight,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BillingRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const BillingRow({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.grey[800])),
          ),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isMultiLine;

  const DetailRow({
    Key? key,
    required this.title,
    required this.value,
    this.isMultiLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: isMultiLine ? 8 : 0),
        ],
      ),
    );
  }
}
