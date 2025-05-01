import 'package:eshop/screen/cart_screen.dart';
import 'package:eshop/screen/dashboard_screen.dart';
import 'package:eshop/screen/direction_screen.dart';
import 'package:eshop/screen/home_screen.dart';
import 'package:eshop/screen/setting_screen.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final String userName;
  final String email;
  final String phone;

  const MainNavigation({
    super.key,
    required this.userName,
    required this.email,
    required this.phone,
  });

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<IconData> icons = [
    Icons.home,
    Icons.directions_bus,
    Icons.apps,
    Icons.shopping_cart,
    Icons.person,
  ];

  final List<String> labels = [
    'Home',
    'Direction',
    'Categories',
    'Cart',
    'Profile',
  ];

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(),
      DirectionScreen(),
      DashboardScreen(),
      CartScreen(),
      SettingScreen(
        userName: widget.userName,
        email: widget.email,
        phone: widget.phone,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Left Floating Selected Item
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(icons[selectedIndex], color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    labels[selectedIndex],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Remaining Navigation Icons (in rounded grey container)
            Expanded(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(icons.length, (index) {
                    if (index == selectedIndex) return const SizedBox();

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Icon(icons[index], color: Colors.grey),
                        ),
                        if (_needsDivider(index))
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 1,
                            height: 24,
                            color: Colors.grey[300],
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _needsDivider(int index) {
    int nextIndex = index + 1;
    if (nextIndex >= icons.length || nextIndex == selectedIndex) return false;
    return true;
  }
}
