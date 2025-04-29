// offer_section.dart
import '../model/offer.dart';
import 'package:flutter/material.dart';
import 'offer_card.dart';

class OffersSection extends StatelessWidget {
  final List<Offer> offers;
  const OffersSection({Key? key, required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: offers.length,
            itemBuilder: (context, index) => OfferCard(offer: offers[index]),
          ),
        ),
      ],
    );
  }
}
