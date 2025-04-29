import 'package:flutter/material.dart';

class AdBanner extends StatelessWidget {
  final Alignment alignment;
  final VoidCallback? onTap;

  const AdBanner({Key? key, this.alignment = Alignment.centerLeft, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.8, // 80% of screen width
        height: screenHeight * 0.2, // 20% of screen height
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: screenHeight * 0.05, // 5% of screen height
              width: screenWidth * 0.30, // 25% of screen width
              decoration: BoxDecoration(
                color: const Color(0xFF9C1414),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
