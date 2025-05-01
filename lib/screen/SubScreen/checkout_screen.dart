import 'package:flutter/material.dart';

import '../../banners/donation_banner.dart';
import '../../banners/price_alert_banner.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: const Icon(Icons.arrow_back),
        actions: const [Icon(Icons.search)],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("NO OFFERED APPLY YET"),
                  Text("See More >", style: TextStyle(color: Colors.orange)),
                ],
              ),
            ),
            _billingDetails(),
            _deliveryOptions(),
            _tipSection(),
            const DonationBanner(),
            _selectedProductsList(),
            _youMayLikeSection(),
            const PriceDropBanner(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Text(
                "OFFERS\nNO OFFERED APPLY YET",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red[800],
        child: const Text(
          "Checkout",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _billingDetails() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "BILLING DETAILS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _billingItem("Items total", Icons.shopping_cart),
            _billingItem("Delivery Charge", Icons.delivery_dining),
            _billingItem("Platform Chargers", Icons.settings),
            _billingItem("Cart Chargers", Icons.receipt_long),
            _billingItem("Tip for your delivery partner", Icons.person),
            const Divider(),
            const Text(
              "Grand total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(title)],
      ),
    );
  }

  Widget _deliveryOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _deliveryCard(
            "Instant Delivery",
            "Charges applicable",
            Icons.timer,
            Colors.red,
          ),
          _deliveryCard(
            "Schedule Delivery",
            "Free Delivery",
            Icons.schedule,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _deliveryCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tipSection() {
    return Container(
      color: Colors.brown[800],
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.delivery_dining, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Tip for your delivery partner",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children:
                [10, 10, 10].map((e) => _tipButton("\$$e")).toList()
                  ..add(_tipButton("CUSTOM")),
          ),
        ],
      ),
    );
  }

  Widget _tipButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.brown,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _selectedProductsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: List.generate(3, (index) => _productItem())),
    );
  }

  Widget _productItem() {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.asset('assets/images/strawberry.png', width: 40),
        title: const Text("Product Name"),
        subtitle: const Text("200 g"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.remove), onPressed: () {}),
            const Text("1"),
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            const SizedBox(width: 8),
            const Text("\$44"),
          ],
        ),
      ),
    );
  }

  Widget _youMayLikeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "You May Like",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("See More >", style: TextStyle(color: Colors.orange)),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder:
                (context, index) => Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset('assets/images/mango_tart.png'),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Golden Mango Tart",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        "\$8",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
