import 'package:flutter/material.dart';

class ViewBasketButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ViewBasketButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 10,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/veg.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/banana.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            const Text(
              "View Basket",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
