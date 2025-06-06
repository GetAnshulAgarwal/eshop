import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Address/add_edit_address_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    setState(() {
      isLoading = true;
    });

    try {
      // API call to get saved addresses
      final response = await http.get(
        Uri.parse('https://mocki.io/v1/c552c7b6-3665-42cb-b69d-585926ebeac8'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          addresses = List<Address>.from(data.map((x) => Address.fromJson(x)));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading addresses: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black, onPressed: () {}),
        title: Text('Address', style: TextStyle(color: Colors.black)),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchAddresses,
                child:
                    addresses.isEmpty
                        ? Center(child: Text('No saved addresses'))
                        : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return _buildAddressCard(address);
                          },
                        ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add address screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditAddressScreen()),
          );

          // If a result was returned (new address)
          if (result != null && result is Address) {
            // Add the new address to the list
            setState(() {
              addresses.add(result);
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Address added successfully')),
            );
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
    IconData iconData;
    String label;

    switch (address.type) {
      case AddressType.home:
        iconData = Icons.home;
        label = 'Home';
        break;
      case AddressType.work:
        iconData = Icons.work;
        label = 'Work';
        break;
      default:
        iconData = Icons.favorite;
        label = address.label;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Map thumbnail using Flutter Maps
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(address.latitude, address.longitude),
                  initialZoom: 15,
                  // Remove interactiveFlags as it's not available
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 20,
                        height: 20,
                        point: LatLng(address.latitude, address.longitude),
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(iconData, size: 16),
                      SizedBox(width: 4),
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(address.fullAddress, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 18),
                  onPressed: () async {
                    // Navigate to edit address screen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddEditAddressScreen(address: address),
                      ),
                    );

                    // If a result was returned (updated address)
                    if (result != null && result is Address) {
                      // Update the address in the list
                      setState(() {
                        final index = addresses.indexWhere(
                          (a) => a.id == result.id,
                        );
                        if (index != -1) {
                          addresses[index] = result;
                        }
                      });

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Address updated successfully')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18),
                  onPressed: () {
                    // Delete address with confirmation
                    _showDeleteConfirmation(address);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Address'),
          content: Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAddress(address);
              },
              child: Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAddress(Address address) async {
    try {
      final response = await http.delete(
        Uri.parse('your-api-endpoint/addresses/${address.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          addresses.removeWhere((a) => a.id == address.id);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Address deleted successfully')));
      } else {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting address: $e')));
    }
  }
}

enum AddressType { home, work, other }

class Address {
  final String id;
  final String fullAddress;
  final String label;
  final AddressType type;
  final double latitude;
  final double longitude;

  Address({
    required this.id,
    required this.fullAddress,
    required this.label,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      fullAddress: json['fullAddress'],
      label: json['label'],
      type: _parseAddressType(json['type']),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  static AddressType _parseAddressType(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return AddressType.home;
      case 'work':
        return AddressType.work;
      default:
        return AddressType.other;
    }
  }
}
