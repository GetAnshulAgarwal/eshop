import 'package:flutter/material.dart';
import '../model/offer.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  const OfferCard({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.42;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              offer.title.toLowerCase(),
              style: TextStyle(
                color: const Color(0xFF9C1414),
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.040,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // 2x2 Grid with internal dividers
          AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double itemSize = constraints.maxWidth / 2 - 6;
                return Stack(
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(6),
                      children:
                          offer.imageUrls
                              .map((url) => _buildImageTile(url))
                              .toList(),
                    ),
                  ],
                );
              },
            ),
          ),

          // "+150 more" label
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${offer.moreCount} more',
                style: TextStyle(
                  fontSize: size.width * 0.025,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTile(String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }
}
