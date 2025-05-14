import 'package:flutter/material.dart';

import '../../buttons/custom_back_button.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top-left brown shape
          Positioned(
            top: 100,
            left: 300,
            child: Image.asset(
              'assets/images/side_upper.png',
              width: size.width * 0.35,
              fit: BoxFit.cover,
            ),
          ),
          // Bottom-right brown shape
          Positioned(
            bottom: 100,
            right: 320,
            child: Image.asset(
              'assets/images/Side_lower.png',
              width: size.width * 0.35,
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // App Logo
                Image.asset('assets/images/app_logo.png', height: 150),
                const SizedBox(height: 40),
                // Illustration
                Image.asset('assets/images/comming.png', height: 160),
                const SizedBox(height: 30),
                // "COMING SOON" Title
                const Text(
                  'COMING SOON',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Description
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "We're working hard behind the scenes to bring you something amazing. Stay tuned – the wait will be worth it!",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                // Page indicator (optional, as in image)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.brown[400],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.brown[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Back button
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, right: 260),
                  child: CustomBackButton(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
