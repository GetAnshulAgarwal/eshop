import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../banners/ad_banner.dart';
import '../buttons/view_basket_button.dart';
import '../widget/main_header.dart';
import '../model/category_model.dart';
import '../services/mock_api_service.dart'; // Updated import
import 'product_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String location = "Fetching location...";
  List<Category> categories = [];
  bool isLoading = true;
  final MockApiService _apiService = MockApiService(); // Using real API service

  @override
  void initState() {
    super.initState();
    _getLocation();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await _apiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading categories: $e')));
      }
    }
  }

  void _navigateToProductList(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProductListScreen(
              selectedCategoryId: category.id,
              selectedCategoryName: category.name,
            ),
      ),
    );
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
      backgroundColor: const Color(0xFFF8F6F5),
      body: SafeArea(
        child: Column(
          children: [
            // Main Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: MainHeader(),
            ),
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
            // Banner
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
                        },
                      ),
                    ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == 2 ? Colors.blueGrey : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            // Fruits Section
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 5,
                              ),
                              child: Text(
                                "Fruits",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 0.8,
                                  ),
                              itemBuilder: (context, idx) {
                                final cat = categories[idx % categories.length];
                                return GestureDetector(
                                  onTap: () => _navigateToProductList(cat),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.10,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          // Updated to use network image instead of asset
                                          child:
                                              cat.image.startsWith('http')
                                                  ? Image.network(
                                                    cat.image,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (c, e, s) => const Icon(
                                                          Icons.image,
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                  : Image.asset(
                                                    cat.image,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (c, e, s) => const Icon(
                                                          Icons.image,
                                                          color: Colors.red,
                                                        ),
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        cat.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // Repeat Fruits Section as in the image
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10,
                              ),
                              child: Text(
                                "Fruits",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categories.length * 2,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.8,
                                  ),
                              itemBuilder: (context, idx) {
                                final cat = categories[idx % categories.length];
                                return GestureDetector(
                                  onTap: () => _navigateToProductList(cat),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.10,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          // Updated to use network image instead of asset
                                          child:
                                              cat.image.startsWith('http')
                                                  ? Image.network(
                                                    cat.image,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (c, e, s) => const Icon(
                                                          Icons.image,
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                  : Image.asset(
                                                    cat.image,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (c, e, s) => const Icon(
                                                          Icons.image,
                                                          color: Colors.red,
                                                        ),
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        cat.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 80),
                            Center(
                              child: ViewBasketButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/basket');
                                },
                              ),
                            ), // for bottom bar space
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
