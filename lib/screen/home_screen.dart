import 'package:eshop/buttons/see_all_product.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../buttons/view_basket_button.dart';
import '../mock_api/api_mock.dart';
import '../model/offer.dart';
import '../banners/ad_banner.dart';
import '../widget/main_header.dart';
import '../widget/offer_section.dart';
import 'SubScreen/Comming_Soon_Screen.dart';
import 'SubScreen/sub_category_screen.dart';

// -----------------------------------------------------------------------------
// HomePage
// -----------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Fetching location...";
  List<dynamic> products = [];
  List<Map<String, dynamic>> mostlySaled = [];
  List<Map<String, dynamic>> bakedProducts = [];

  Map<String, dynamic>? adData;
  late List<Offer> offers;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadMockData();
    _loadMostlySaled();
    _loadBakedProducts();
  }

  void _loadBakedProducts() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        products = MockData.getMockProducts();
        offers = MockData.getMockOffers();
        bakedProducts = MockData.getMockBakedProducts();
        adData = MockData.getAdSectionData();
        isLoading = false;
      });
    });
  }

  void _loadMostlySaled() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        products = MockData.getMockProducts();
        offers = MockData.getMockOffers();
        mostlySaled = MockData.getMockMostlySaled();
        adData = MockData.getAdSectionData();
        isLoading = false;
      });
    });
  }

  void _loadMockData() {
    // Simulate network delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        //Will be used once API is loaded
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
            const MainHeader(),
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
            //Fruit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fruit",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(onPressed: () {}, child: Text("See More >")),
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
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return Stack(
                                    children: [
                                      // 🔻 The actual popup screen (draggable sheet)
                                      DraggableScrollableSheet(
                                        initialChildSize: 0.6,
                                        minChildSize: 0.4,
                                        maxChildSize: 0.95,
                                        expand: false,
                                        builder: (context, scrollController) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            child: CategoryPopupScreen(
                                              categoryName: item['name'],
                                              scrollController:
                                                  scrollController,
                                            ),
                                          );
                                        },
                                      ),

                                      // ❌ The floating close button OUTSIDE the sheet
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.7,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
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
                            ),
                          );
                        },
                      ),
            ),

            // Baked Products Section
            SizedBox(height: 20),
            Text(
              "Mostly Saled",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("Sponsored", style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bakedProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = bakedProducts[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent, width: 4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              product['image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Flavour : ${product['flavour']}"),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(product['rating'].toString()),
                                    Spacer(),
                                    Icon(Icons.add_circle, color: Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            SizedBox(height: 10),
            Center(
              child: SeeAllProductsButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products');
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ComingSoonScreen()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/img.png', // Place your image here
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Backed Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("Sponsored", style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bakedProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = bakedProducts[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent, width: 4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              product['image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Flavour : ${product['flavour']}"),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(product['rating'].toString()),
                                    Spacer(),
                                    Icon(Icons.add_circle, color: Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

            // Place this below your SizedBox(height: 20),
            // and above the rest of your content.
            // View Basket Button
            SizedBox(height: 10),
            Center(
              child: SeeAllProductsButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products ');
                },
              ),
            ),
            /*SizedBox(height: 20),
            if (adData != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Image.asset(
                          adData!['brand']['logo'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adData!['brand']['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.brown[900],
                              ),
                            ),
                            Text(
                              adData!['brand']['tagline'],
                              style: TextStyle(
                                color: Colors.brown[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Ad",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Product Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: adData!['products'].length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = adData!['products'][index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product['image'],
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['title'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Flavour : ${product['flavour']}",
                                      style: TextStyle(fontSize: 10),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(width: 5),
                                        Text(product['rating'].toString()),
                                        Spacer(),
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 10),
                    Center(
                      child: SeeAllProductsButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/products');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            Center(
              child: ViewBasketButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/basket');
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
