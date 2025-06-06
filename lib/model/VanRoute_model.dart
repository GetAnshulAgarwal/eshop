import 'package:latlong2/latlong.dart';

class VanRouteLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  VanRouteLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory VanRouteLocation.fromJson(Map<String, dynamic> json) {
    return VanRouteLocation(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }

  // Convert to LatLng for flutter_map
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
