import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'host_ride_screen.dart';
import 'join_ride_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(17.385044, 78.486671); // Default to Hyderabad

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("RideToGether"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🗺️ Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentPosition, zoom: 15),
                ),
              );
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),

        
          // Positioned(
          //   top: 100,
          //   left: 20,
          //   right: 20,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.8),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
              
          //   ),
          // ),

      
          Positioned(
            bottom: 150,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.extended(
                  heroTag: 'host',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HostRideScreen()),
                  ),
                  label: Text("Host Ride",style: TextStyle(fontSize: 14,color: Colors.black),),
                  icon: Icon(Icons.add_road,color: Colors.black,),
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'join',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => JoinRideScreen()),
                  ),


                  label: Text("Join Ride",style: TextStyle(fontSize: 14,color: Colors.black),),
                  icon: Icon(Icons.search,color: Colors.black,),
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'track',
                  onPressed: () {
                    if (user != null) {
                      // TODO: Navigate to track screen
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please log in to track a ride")),
                      );
                    }
                  },
                  label: Text("Instant Ride",style: TextStyle(fontSize: 14,color: Colors.black),),
                  icon: Icon(Icons.gps_fixed,color: Colors.black,),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),


          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _vehicleBox(icon: Icons.directions_car, label: "Car"),
                    _vehicleBox(icon: Icons.pedal_bike, label: "Bike"),
                    _vehicleBox(icon: Icons.two_wheeler, label: "Auto"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleBox({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 36, color: Colors.black),
          // To replace with image later:
          // child: Image.asset('assets/car.png', fit: BoxFit.contain),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
