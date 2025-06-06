import 'package:flutter/material.dart';
import '../model/category_model.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          color: isSelected ? Colors.red.shade50 : Colors.transparent,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.shade100,
              radius: 30,
              child: _buildCategoryImage(),
            ),
            const SizedBox(height: 5),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage() {
    return Image.network(
      category.image,
      width: 30,
      height: 30,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
        );
      },
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }
}
