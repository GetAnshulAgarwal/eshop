import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';

import '../model/offer.dart';
import '../widget/ad_banner.dart';
import '../widget/offer_card.dart';
import '../widget/offer_section.dart';

// Mock data for UI testing
class MockData {
  static List<Map<String, dynamic>> getMockProducts() {
    return [
      {'name': 'Rice', 'image': 'https://picsum.photos/200?random=1'},
      {'name': 'Flour', 'image': 'https://picsum.photos/200?random=2'},
      {'name': 'Sugar', 'image': 'https://picsum.photos/200?random=3'},
      {'name': 'Oil', 'image': 'https://picsum.photos/200?random=4'},
      {'name': 'Salt', 'image': 'https://picsum.photos/200?random=5'},
      {'name': 'Pasta', 'image': 'https://picsum.photos/200?random=6'},
    ];
  }

  static List<Offer> getMockOffers() {
    return [
      Offer(
        title: "upto 30% off",
        imageUrls: [
          'assets/images/veg.png',
          'assets/images/banana.png',
          'assets/images/veg.png',
          'assets/images/banana.png',
        ],
        moreCount: 20,
      ),
      Offer(
        title: "buy one get one",
        imageUrls: [
          'assets/images/veg.png',
          'assets/images/banana.png',
          'assets/images/veg.png',
          'assets/images/banana.png', // Bananas
        ],
        moreCount: 15,
      ),
    ];
  }
}

// -----------------------------------------------------------------------------
// HomePage
// -----------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Fetching location...";
  List<dynamic> products = [];
  late List<Offer> offers;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadMockData();
  }

  void _loadMockData() {
    // Simulate network delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        products = MockData.getMockProducts();
        offers = MockData.getMockOffers();
        isLoading = false;
      });
    });
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => location = 'Location permission denied');
        return;
      }
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final place = placemarks.first;
      setState(() {
        location = "${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() => location = "Location not found");
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
                    SizedBox(width: 4),
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

            // Search Bar
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

            // Filter Chips
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
                  SizedBox(width: 8),
                  Chip(label: Text("🍩")),
                  SizedBox(width: 8),
                  Chip(label: Text("🍕")),
                  SizedBox(width: 8),
                  Chip(label: Text("🍗")),
                  SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: Text("See More →")),
                ],
              ),
            ),

            // Ad banner
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                padding: EdgeInsets.symmetric(vertical: 16),
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: AdBanner(
                        alignment: Alignment.bottomLeft,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Banner #$index tapped!')),
                          );

                          // You can also navigate:
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => YourTargetPage()));
                        },
                      ),
                    ),
              ),
            ),

            // Offers Section
            SizedBox(height: 16),
            isLoading
                ? SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                )
                : OffersSection(offers: offers),

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

            // Products Horizontal Scroll
            SizedBox(
              height: 110,
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (ctx, i) {
                          final item = products[i];
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    item['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey.shade300,
                                          child: Center(
                                            child: Text(
                                              item['name'].substring(0, 1),
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(item['name'] ?? ''),
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
}
