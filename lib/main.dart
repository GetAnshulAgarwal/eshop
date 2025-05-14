import 'package:eshop/screen/SubScreen/Comming_Soon_Screen.dart';
import 'package:flutter/material.dart';
import 'package:eshop/authentication/login_screen_authentication.dart';
import 'package:eshop/screen/SubScreen/checkout_screen.dart';
import 'package:eshop/screen/SubScreen/setting_profile_screen.dart';
import 'package:eshop/screen/category_screen.dart';
import 'package:eshop/screen/home_screen.dart';
import 'package:eshop/screen/setting_screen.dart';

import 'navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main':
            (context) =>
                const MainNavigation(userName: '', phone: '', email: ''),
        '/home': (context) => const HomePage(),
      },
    );
    /**/
    // '/profile': (context) => const SettingProfileScreen(),
  }
}
