import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MainHeader extends StatefulWidget {
  const MainHeader({super.key});

  @override
  State<MainHeader> createState() => _MainHeaderState();
}

class _MainHeaderState extends State<MainHeader> {
  String location = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => location = 'Location permission denied');
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final place = placemarks.first;

      setState(() {
        location = "${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() => location = "Location not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.location_pin, color: Colors.red),
            const SizedBox(width: 4),
            Text(location, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.notifications_none),
            SizedBox(width: 10),
            Icon(Icons.shopping_bag),
          ],
        ),
      ],
    );
  }
}
