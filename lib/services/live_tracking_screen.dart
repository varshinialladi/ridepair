// screens/live_tracking_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/live_location_service.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String driverId;

  LiveTrackingScreen({required this.driverId});

  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  Marker? _driverMarker;
  LatLng _initialPosition = LatLng(17.385044, 78.486671); // Hyderabad default
  StreamSubscription<LatLng>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToDriverLocation();
  }

  void _subscribeToDriverLocation() {
    _locationSubscription =
        LiveLocationService.getDriverLocationStream(widget.driverId).listen((
          LatLng newLocation,
        ) {
          _updateDriverMarker(newLocation);
        });
  }

  void _updateDriverMarker(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;

    setState(() {
      _driverMarker = Marker(
        markerId: MarkerId("driver"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: "Driver"),
      );
    });

    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Driver Tracking")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        markers: _driverMarker != null ? {_driverMarker!} : {},
        onMapCreated: (controller) => _mapController.complete(controller),
      ),
    );
  }
}
