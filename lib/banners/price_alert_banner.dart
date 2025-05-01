import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/banner_model.dart';

class PriceDropBanner extends StatefulWidget {
  const PriceDropBanner({Key? key}) : super(key: key);

  @override
  _PriceDropBannerState createState() => _PriceDropBannerState();
}

class _PriceDropBannerState extends State<PriceDropBanner> {
  List<BannerModel> banners = [];

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    final response = await http.get(
      Uri.parse("https://yourapi.com/banners?type=priceDrop"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['banners'];
      setState(() {
        banners = jsonList.map((json) => BannerModel.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(banner.imageUrl, width: 180),
          );
        },
      ),
    );
  }
}
