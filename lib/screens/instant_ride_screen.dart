// screens/instant_ride_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

class InstantRideScreen extends StatefulWidget {
  @override
  _InstantRideScreenState createState() => _InstantRideScreenState();
}

class _InstantRideScreenState extends State<InstantRideScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  LatLng? _userLocation;
  Set<Marker> _driverMarkers = {};

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final pos = await LocationService.getCurrentLocation();
    _userLocation = LatLng(pos.latitude, pos.longitude);
    _loadNearbyDrivers();
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_userLocation!, 15));
    setState(() {});
  }

  void _loadNearbyDrivers() {
    // Mock driver locations near the user
    final mockDrivers = [
      LatLng(_userLocation!.latitude + 0.002, _userLocation!.longitude + 0.001),
      LatLng(_userLocation!.latitude - 0.002, _userLocation!.longitude - 0.001),
      LatLng(_userLocation!.latitude + 0.001, _userLocation!.longitude - 0.002),
    ];

    _driverMarkers = {
      for (int i = 0; i < mockDrivers.length; i++)
        Marker(
          markerId: MarkerId('driver_$i'),
          position: mockDrivers[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: "Driver ${i + 1}"),
        ),
    };

    setState(() {});
  }

  void _requestRideNow() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Ride Requested"),
        content: Text("Your ride request was sent to nearby drivers."),
        actions: [
          TextButton(
            child: Text("Okay"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Instant Ride")),
      body: _userLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _userLocation!,
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  markers: _driverMarkers,
                  onMapCreated: (controller) =>
                      _mapController.complete(controller),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _requestRideNow,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.indigo,
                    ),
                    child: Text(
                      "Request Ride Now",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
