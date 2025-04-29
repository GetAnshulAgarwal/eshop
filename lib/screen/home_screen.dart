import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Fetching location...";
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
    _fetchProducts();
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        location = "${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() {
        location = "Location not found";
      });
    }
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse("https://yourapi.com/products"));
    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
      });
    } else {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            // Location + Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.red),
                    Text(location),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.notifications_none),
                    SizedBox(width: 10),
                    Icon(Icons.shopping_bag),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),

            // Search Box
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "What would you like to eat?",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 10),

            // Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Chip(
                    label: Text("All"),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Chip(label: Text("Fruity Cakes 🍰")),
                  Chip(label: Text("🍩")),
                  Chip(label: Text("🍕")),
                  Chip(label: Text("🍗")),
                  TextButton(onPressed: () {}, child: Text("See More →")),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Banner (Static Placeholder)
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            // Offers (Static Titles, Dynamic Content)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOfferCard("Upto 30% off"),
                _buildOfferCard("Buy one get one"),
              ],
            ),

            SizedBox(height: 15),

            // Grocery & Staples
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Grocery & Staples",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(onPressed: () {}, child: Text("See More →")),
              ],
            ),

            // Product Horizontal Scroll
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: Image.network(
                          item['image'],
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Text(item['name'] ?? 'Dry Fruit'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(String title) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/veg.png', width: 40, height: 40),
                Image.asset('assets/images/banana.png', width: 40, height: 40),
              ],
            ),
            Text("+150 more", style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
