import 'package:flutter/material.dart';
import '../buttons/view_basket_button.dart';
import '../model/product_model.dart';
import '../model/category_model.dart';
import '../services/mock_api_service.dart'; // Updated import
import '../widget/product_card.dart';
import '../widget/category_item.dart';

class ProductListScreen extends StatefulWidget {
  final String selectedCategoryId;
  final String selectedCategoryName;

  const ProductListScreen({
    Key? key,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Category> categories = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  int basketCount = 2;
  late String selectedCategoryId;
  late String selectedCategoryName;
  final MockApiService _apiService = MockApiService(); // Using real API

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.selectedCategoryId;
    selectedCategoryName = widget.selectedCategoryName;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch all categories
      final fetchedCategories = await _apiService.fetchCategories();

      // Fetch products for the selected category
      final fetchedProducts = await _apiService.fetchProductsByCategory(
        selectedCategoryName,
      );

      setState(() {
        categories = fetchedCategories;
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  void filterProductsByCategory(String categoryId, String categoryName) {
    setState(() {
      isLoading = true;
    });

    setState(() {
      selectedCategoryId = categoryId;
      selectedCategoryName = categoryName;
    });

    _apiService
        .fetchProductsByCategory(categoryName)
        .then((fetchedProducts) {
          setState(() {
            filteredProducts = fetchedProducts;
            isLoading = false;
          });
        })
        .catchError((e) {
          setState(() {
            isLoading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error filtering products: $e')),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          selectedCategoryName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Row(
                    children: [
                      // Left sidebar for categories
                      SizedBox(
                        width: 100,
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CategoryItem(
                              category: categories[index],
                              isSelected:
                                  categories[index].id == selectedCategoryId,
                              onTap:
                                  () => filterProductsByCategory(
                                    categories[index].id,
                                    categories[index].name,
                                  ),
                            );
                          },
                        ),
                      ),

                      // Main content - Product grid
                      Expanded(
                        child:
                            filteredProducts.isEmpty
                                ? const Center(child: Text('No products found'))
                                : GridView.builder(
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.75,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      product: filteredProducts[index],
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),

                  // View Basket button
                  const SizedBox(height: 80),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ViewBasketButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/basket');
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
