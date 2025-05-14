import 'package:flutter/material.dart';

class SeeAllProductsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SeeAllProductsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 12,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/banana.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/veg.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            const Text(
              "See all products",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF361B0D),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF361B0D),
            ),
          ],
        ),
      ),
    );
  }
}
