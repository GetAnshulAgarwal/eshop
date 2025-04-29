import 'package:eshop/screen/home_screen.dart';
import 'package:flutter/material.dart';
// TODO: Create these or replace with your real pages
// import 'direction_page.dart';
// import 'dashboard_page.dart';
// import 'cart_page.dart';
// import 'settings_page.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<IconData> icons = [
    Icons.home,
    Icons.directions_bus,
    Icons.dashboard,
    Icons.shopping_cart,
    Icons.person,
  ];

  final List<String> labels = [
    'Home',
    'Direction',
    'Dashboard',
    'Cart',
    'Setting',
  ];

  final List<Widget> pages = [
    HomePage(), // You already have this
    Placeholder(), // TODO: Replace with DirectionPage()
    Placeholder(), // TODO: Replace with DashboardPage()
    Placeholder(), // TODO: Replace with CartPage()
    Placeholder(), // TODO: Replace with SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration:
                      isSelected
                          ? BoxDecoration(
                            color: Colors.red[800],
                            borderRadius: BorderRadius.circular(30),
                          )
                          : BoxDecoration(),
                  child: Row(
                    children: [
                      Icon(
                        icons[index],
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            labels[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
