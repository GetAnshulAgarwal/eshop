import 'package:eshop/screen/SubScreen/checkout_screen.dart';
import 'package:eshop/screen/SubScreen/setting_profile_screen.dart';
import 'package:eshop/screen/home_screen.dart';
import 'package:eshop/screen/setting_screen.dart';
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
      home: HomePage(
        //userName: "Rahul Sihag",
        //email: "rsihagds@gmail.com",
        //phone: "9812012464",
      ),
    );
  }
}
