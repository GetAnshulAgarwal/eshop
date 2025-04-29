import 'package:flutter/material.dart';

class CustomNavBarDemo extends StatefulWidget {
  @override
  _CustomNavBarDemoState createState() => _CustomNavBarDemoState();
}

class _CustomNavBarDemoState extends State<CustomNavBarDemo> {
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
    'direction',
    'dashboard',
    'cart',
    'setting',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("Page ${selectedIndex + 1}")),
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
