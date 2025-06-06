import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../buttons/view_basket_button.dart';
import '../model/VanRoute_model.dart';
import '../model/van_booking_progress.dart';
import '../model/van_route_progress.dart';
import '../services/api_service_for_van.dart';
import '../widget/main_header.dart';

class VanRoutePage extends StatefulWidget {
  const VanRoutePage({Key? key}) : super(key: key);

  @override
  State<VanRoutePage> createState() => _VanRoutePageState();
}

class _VanRoutePageState extends State<VanRoutePage> {
  final MapController _mapController = MapController();
  final VanRouteApiService _apiService = VanRouteApiService();

  // Timer for periodically updating route progress
  Timer? _progressTimer;

  // State variables using our model classes
  List<VanRouteLocation> _routeLocations = [];
  List<String> _routeStops = [];
  RouteProgress _routeProgress = RouteProgress(
    currentProgress: 0.3,
    startTime: "6kM",
    distance: "16KM",
  );
  Basket? _basket;

  bool _isLoading = true;
  bool _locationLoading = true;
  bool _isFullScreenMap = false;
  bool _isAddressLoading = false;
  LatLng _currentLocation = LatLng(28.6139, 77.2090); // Default to Delhi
  LatLng _selectedLocation = LatLng(
    28.6139,
    77.2090,
  ); // Default same as current location
  String _selectedAddress = "Loading address..."; // Default address message

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadData();

    // Set up a timer to periodically update route progress
    _progressTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateRouteProgress();
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _locationLoading = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled')),
          );
        }
        setState(() {
          _locationLoading = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          setState(() {
            _locationLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied'),
            ),
          );
        }
        setState(() {
          _locationLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _selectedLocation =
              _currentLocation; // Initially set selected location to current location
          _locationLoading = false;
        });

        // Get address for the current location
        _getAddressFromLatLng(_currentLocation);

        Future.delayed(const Duration(milliseconds: 500), () {
          _mapController.move(_currentLocation, 14.0);
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
        setState(() {
          _locationLoading = false;
        });
      }
    }
  }

  // Method to convert LatLng coordinates to a readable address
  Future<void> _getAddressFromLatLng(LatLng location) async {
    setState(() {
      _isAddressLoading = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '';

        // Build a formatted address string
        if (place.street != null && place.street!.isNotEmpty) {
          address += place.street!;
        }

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.subLocality!;
        }

        if (place.locality != null && place.locality!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.locality!;
        }

        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.postalCode!;
        }

        if (place.country != null && place.country!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.country!;
        }

        // If we couldn't build a proper address, use coordinates
        if (address.isEmpty) {
          address =
              'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
        }

        if (mounted) {
          setState(() {
            _selectedAddress = address;
            _isAddressLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _selectedAddress = 'Address not found';
            _isAddressLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error getting address: $e');
      if (mounted) {
        setState(() {
          _selectedAddress = 'Error getting address';
          _isAddressLoading = false;
        });
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all data in parallel using the API service with the base URL
      final locationsF = _apiService.getRouteLocations();
      final routesF = _apiService.getTodayRoutes();
      final progressF = _apiService.getRouteProgress();
      final basketF = _apiService.getBasket();

      final results = await Future.wait([
        locationsF,
        routesF,
        progressF,
        basketF,
      ]);

      final locations = results[0] as List<VanRouteLocation>;
      final routes = results[1] as List<String>;
      final progress = results[2] as RouteProgress;
      final basket = results[3] as Basket;

      if (mounted) {
        setState(() {
          _routeLocations = locations;
          _routeStops = routes;
          _routeProgress = progress;
          _basket = basket;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  // Update route progress from the API
  Future<void> _updateRouteProgress() async {
    try {
      final progress = await _apiService.getRouteProgress();
      if (mounted) {
        setState(() {
          _routeProgress = progress;
        });
      }
    } catch (e) {
      print('Error updating route progress: $e');
    }
  }

  // Toggle to full screen map mode
  void _toggleFullScreenMap() {
    setState(() {
      _isFullScreenMap = !_isFullScreenMap;

      if (_isFullScreenMap) {
        // When entering full screen, center the map on the current/selected location
        Future.delayed(const Duration(milliseconds: 100), () {
          _mapController.move(_selectedLocation, 15.0);
        });
      }
    });
  }

  // Handle map tap to update selected location
  void _handleMapTap(LatLng tappedPoint) {
    if (_isFullScreenMap) {
      setState(() {
        _selectedLocation = tappedPoint;
      });

      // Get address for the tapped location
      _getAddressFromLatLng(tappedPoint);
    }
  }

  // Confirm selected location and exit full screen mode
  void _confirmLocation() {
    _toggleFullScreenMap();

    // Show a success message with the selected address
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location confirmed: ${_selectedAddress}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreenMap) {
      return _buildFullScreenMap();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow resize when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            // Main Header (fixed at top)
            const MainHeader(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),

                    // Flutter Map View with route locations from API
                    GestureDetector(
                      onTap: _toggleFullScreenMap,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Stack(
                              children: [
                                FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: _currentLocation,
                                    initialZoom: 14.0,
                                    onMapReady: () {
                                      _mapController.move(
                                        _currentLocation,
                                        14.0,
                                      );
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                    // Show all route locations from the API
                                    MarkerLayer(
                                      markers: [
                                        // Current location marker
                                        Marker(
                                          width: 40,
                                          height: 40,
                                          point: _currentLocation,
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                        ),
                                        // Selected location marker (if different from current)
                                        if (_selectedLocation !=
                                            _currentLocation)
                                          Marker(
                                            width: 40,
                                            height: 40,
                                            point: _selectedLocation,
                                            child: const Icon(
                                              Icons.pin_drop,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                        // Route location markers
                                        ..._routeLocations
                                            .map(
                                              (location) => Marker(
                                                width: 40,
                                                height: 40,
                                                point: location.toLatLng(),
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  ],
                                ),
                                // Show loading indicator for location
                                if (_locationLoading)
                                  const Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                // Show loading indicator for data
                                if (_isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  ),
                                // Tap to expand indicator
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.fullscreen,
                                          size: 16,
                                          color: Colors.black87,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Tap to expand',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                title: "Instant VAN",
                                subtitle: "BOOKING",
                                description: "van ready to meet your demands",
                                onTap: _bookInstantVan,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 80,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: _buildActionButton(
                                title: "Schedule VAN",
                                subtitle: "BOOKING",
                                description:
                                    "set date on your desired schedule",
                                onTap: _scheduleVanBooking,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Today's Van Route Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with correct styling
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "TODAY VAN ROUTE IN YOU AREA",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF783F04),
                              ),
                            ),
                          ),

                          // Time Slider with correct styling and data from API
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              children: [
                                Text(
                                  _routeProgress.startTime,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      thumbColor: Colors.red,
                                      activeTrackColor: Colors.red,
                                      inactiveTrackColor: Colors.grey.shade300,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 16,
                                      ),
                                      trackHeight: 4,
                                    ),
                                    child: Slider(
                                      value: _routeProgress.currentProgress,
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ),
                                Text(
                                  _routeProgress.distance,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Route Stops List
                          _isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              )
                              : _routeStops.isEmpty
                              ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text("No routes available today"),
                                ),
                              )
                              : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _routeStops.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          _routeStops[index],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                          // Add padding at bottom for keyboard
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // View Basket Button (fixed at bottom)
            Container(
              width: double.infinity,
              height: 60,
              color: const Color(0xFFB21E1E),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ViewBasketButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/basket');
                    },
                    // Display the basket count from API if available
                    itemCount: _basket?.itemCount ?? 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the full-screen map view
  Widget _buildFullScreenMap() {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 15.0,
              onTap: (_, point) => _handleMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  // Current location marker (blue)
                  Marker(
                    width: 40,
                    height: 40,
                    point: _currentLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  // Selected location marker (red)
                  Marker(
                    width: 40,
                    height: 40,
                    point: _selectedLocation,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Header with back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _toggleFullScreenMap,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Tap on the map to select location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location info and confirm button
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _isAddressLoading
                          ? const Row(
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFB21E1E),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Loading address...'),
                            ],
                          )
                          : Text(
                            _selectedAddress,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                      const SizedBox(height: 4),
                      Text(
                        'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _confirmLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB21E1E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM LOCATION',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Center indicator to help user align with selected point
          Center(
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.7),
                  width: 2,
                ),
              ),
            ),
          ),

          // Recenter button
          Positioned(
            bottom: 160,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  setState(() {
                    _selectedLocation = _currentLocation;
                    _mapController.move(_currentLocation, 15.0);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFB21E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFB21E1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                'assets/images/right_side.png',
                width: 35,
                height: 35,
                errorBuilder:
                    (context, error, stackTrace) => Image.asset(
                      'assets/images/left_side.png',
                      width: 35,
                      height: 35,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.access_time,
                            color: Color(0xFFB21E1E),
                            size: 35,
                          ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Book instant van through API
  void _bookInstantVan() async {
    try {
      // Use the selected address instead of coordinates
      String locationName = _selectedAddress;

      final result = await _apiService.bookInstantVan(location: locationName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book instant van: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Schedule van booking through API
  // Schedule van booking through a custom dialog form
  // Schedule van booking through a custom dialog form
  // Schedule van booking through a custom dialog form
  void _scheduleVanBooking() {
    // Create text editing controller for the remark field
    final remarkController = TextEditingController();

    // Use these variables to track the selection
    DateTime? selectedDateTime;
    TimeOfDay? selectedTimeOfDay;

    // Show the dialog with special handling for keyboard
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Schedule Delivery",
      pageBuilder: (context, animation1, animation2) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Close button row at the top
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            right: 16.0,
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                        // Scrollable content area
                        Flexible(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom > 0
                                      ? MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom +
                                          20
                                      : 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Date field
                                GestureDetector(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDateTime ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 14),
                                      ),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                  primary: Color(0xFFB21E1E),
                                                  onPrimary: Colors.white,
                                                ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (date != null) {
                                      setState(() {
                                        selectedDateTime = date;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          selectedDateTime == null
                                              ? 'Date'
                                              : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}",
                                          style: TextStyle(
                                            color:
                                                selectedDateTime == null
                                                    ? Colors.grey
                                                    : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Time field
                                GestureDetector(
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          selectedTimeOfDay ?? TimeOfDay.now(),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                  primary: Color(0xFFB21E1E),
                                                  onPrimary: Colors.white,
                                                ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (time != null) {
                                      setState(() {
                                        selectedTimeOfDay = time;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          selectedTimeOfDay == null
                                              ? 'TIME'
                                              : "${selectedTimeOfDay!.hour.toString().padLeft(2, '0')}:${selectedTimeOfDay!.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(
                                            color:
                                                selectedTimeOfDay == null
                                                    ? Colors.grey
                                                    : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Remark field
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: remarkController,
                                          maxLines: 3,
                                          decoration: const InputDecoration(
                                            hintText: 'Remark for us',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Book Now button
                                ElevatedButton(
                                  onPressed: () async {
                                    // Check if date and time are selected
                                    if (selectedDateTime == null ||
                                        selectedTimeOfDay == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please select both date and time',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Create a complete DateTime object
                                    final dateTime = DateTime(
                                      selectedDateTime!.year,
                                      selectedDateTime!.month,
                                      selectedDateTime!.day,
                                      selectedTimeOfDay!.hour,
                                      selectedTimeOfDay!.minute,
                                    );

                                    final formattedDate =
                                        "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}";
                                    final formattedTime =
                                        "${selectedTimeOfDay!.hour.toString().padLeft(2, '0')}:${selectedTimeOfDay!.minute.toString().padLeft(2, '0')}";

                                    Navigator.pop(context);

                                    try {
                                      // Use the selected location instead of current location
                                      String locationName = _selectedAddress;

                                      final result = await _apiService
                                          .scheduleVanBooking(
                                            location: locationName,
                                            dateTime: dateTime,
                                            remark: remarkController.text,
                                          );

                                      if (mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  20,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Close button
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: GestureDetector(
                                                        onTap:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 10),

                                                    // Success icon
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Color(
                                                              0xFF7ED957,
                                                            ), // Green color
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      child: const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 50,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    // Success message
                                                    const Text(
                                                      'VAN Successfully booked on\nthe schedule',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 10),

                                                    // Date and time
                                                    Text(
                                                      '$formattedTime, $formattedDate',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to schedule van: $e',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB21E1E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'BOOK NOW',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Extra padding at the bottom when keyboard appears
                                if (MediaQuery.of(context).viewInsets.bottom >
                                    0)
                                  SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
