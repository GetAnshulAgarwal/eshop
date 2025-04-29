import 'package:flutter/material.dart';
import 'package:eshop/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigation(), // Launch the app with navigation bar
    );
  }
}
