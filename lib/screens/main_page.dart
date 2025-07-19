// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:ridetogther/assistance/assistent_method.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   Completer<GoogleMapController> _controller = Completer();
//   LatLng? _currentPosition;
//   LatLng? _selectedPosition;
//   final Set<Marker> _markers = {};
//   String? _address;
//   String userName = '';
//   String userEmail = '';

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//       _markers.add(
//         Marker(
//           markerId: MarkerId('current_location'),
//           position: _currentPosition!,
//           infoWindow: InfoWindow(title: 'My Current Location'),
//         ),
//       );
//     });

//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 15));
//   }

//   void _onMapTapped(LatLng tappedPoint) {
//     setState(() {
//       _selectedPosition = tappedPoint;
//       _markers.removeWhere((m) => m.markerId.value == 'selected_location');
//       _markers.add(
//         Marker(
//           markerId: MarkerId('selected_location'),
//           position: tappedPoint,
//           infoWindow: InfoWindow(title: 'Selected Location'),
//         ),
//       );
//     });
//   }

//   void _setLocation() {
//     if (_selectedPosition != null) {
//       setState(() {
//         _address =
//             'Lat: ${_selectedPosition!.latitude.toStringAsFixed(6)}, '
//             'Lng: ${_selectedPosition!.longitude.toStringAsFixed(6)}';
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Location set to: ${_selectedPosition!.latitude}, ${_selectedPosition!.longitude}',
//           ),
//         ),
//       );
//     }
//   }

//   void _setCurrentLocation() {
//     if (_currentPosition != null) {
//       setState(() {
//         _selectedPosition = _currentPosition;
//         _address =
//             'Current Location: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
//             '${_currentPosition!.longitude.toStringAsFixed(6)}';

//         // Update markers
//         _markers.removeWhere((m) => m.markerId.value == 'selected_location');
//         _markers.add(
//           Marker(
//             markerId: MarkerId('selected_location'),
//             position: _currentPosition!,
//             infoWindow: InfoWindow(title: 'Selected Location (Current)'),
//           ),
//         );
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Current location set as selected location')),
//       );
//     }
//     // userName = userModeCurrentInfo!.name!;

//     // initializerGeoFireListener();
//     // AssistentMethod.readTripsKeyForOnlineUser(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pick Location")),
//       body: _currentPosition == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 GoogleMap(
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                   },
//                   initialCameraPosition: CameraPosition(
//                     target: _currentPosition!,
//                     zoom: 15,
//                   ),
//                   markers: _markers,
//                   onTap: _onMapTapped,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                 ),
//                 Positioned(
//                   top: 40,
//                   left: 20,
//                   right: 20,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black54, width: 1),
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.white,
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Text(
//                       _address ?? "Tap on map or use current location",
//                       style: TextStyle(fontSize: 16, color: Colors.black54),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 100,
//                   left: 20,
//                   right: 20,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: _setCurrentLocation,
//                         child: Text('Use Current Location'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _selectedPosition != null
//                             ? _setLocation
//                             : null,
//                         child: Text('Set Location'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
