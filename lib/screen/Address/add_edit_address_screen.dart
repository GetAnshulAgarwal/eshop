import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../ProfileSubScreen/saved_address_screen.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address; // Null for adding new address, non-null for editing

  AddEditAddressScreen({this.address});

  @override
  _AddEditAddressScreenState createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  AddressType _selectedType = AddressType.home;

  // Default coordinates
  double _latitude = 28.7041;
  double _longitude = 77.1025;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize with existing data if editing
    if (widget.address != null) {
      _labelController = TextEditingController(text: widget.address!.label);
      _addressController = TextEditingController(
        text: widget.address!.fullAddress,
      );
      _selectedType = widget.address!.type;
      _latitude = widget.address!.latitude;
      _longitude = widget.address!.longitude;
    } else {
      _labelController = TextEditingController();
      _addressController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Map preview
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(_latitude, _longitude),
                              initialZoom: 15,
                              onTap: (tapPosition, latLng) {
                                setState(() {
                                  _latitude = latLng.latitude;
                                  _longitude = latLng.longitude;
                                  // You could reverse geocode here to get address
                                });
                              },
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
                                    width: 40,
                                    height: 40,
                                    point: LatLng(_latitude, _longitude),
                                    child: Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Address Type Selection
                        Text(
                          'Address Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            _buildTypeButton(
                              AddressType.home,
                              'Home',
                              Icons.home,
                            ),
                            SizedBox(width: 12),
                            _buildTypeButton(
                              AddressType.work,
                              'Work',
                              Icons.work,
                            ),
                            SizedBox(width: 12),
                            _buildTypeButton(
                              AddressType.other,
                              'Other',
                              Icons.location_on,
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Label Field
                        TextFormField(
                          controller: _labelController,
                          decoration: InputDecoration(
                            labelText: 'Label',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.label),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a label';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16),

                        // Address Field
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an address';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveAddress,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'SAVE ADDRESS',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildTypeButton(AddressType type, String label, IconData icon) {
    bool isSelected = _selectedType == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final addressData = {
          'label': _labelController.text,
          'fullAddress': _addressController.text,
          'type': _selectedType.toString().split('.').last,
          'latitude': _latitude,
          'longitude': _longitude,
        };

        // Add ID if editing
        if (widget.address != null) {
          addressData['id'] = widget.address!.id;
        }

        final Uri uri = Uri.parse(
          'your-api-endpoint/addresses' +
              (widget.address != null ? '/${widget.address!.id}' : ''),
        );

        final response =
            widget.address != null
                ? await http.put(
                  uri,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(addressData),
                )
                : await http.post(
                  uri,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(addressData),
                );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          throw Exception('Failed to save address');
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving address: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
