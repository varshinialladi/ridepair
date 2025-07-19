// services/live_location_service.dart
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveLocationService {
  static StreamSubscription<Position>? _positionStream;

  static void startSendingLocation(String userId) {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // in meters
          ),
        ).listen((Position position) {
          FirebaseFirestore.instance
              .collection('live_locations')
              .doc(userId)
              .set({
                'lat': position.latitude,
                'lng': position.longitude,
                'timestamp': FieldValue.serverTimestamp(),
              });
        });
  }

  static void stopSendingLocation() {
    _positionStream?.cancel();
  }

  static Stream<LatLng> getDriverLocationStream(String driverId) {
    return FirebaseFirestore.instance
        .collection('live_locations')
        .doc(driverId)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data != null) {
            return LatLng(data['lat'], data['lng']);
          } else {
            return const LatLng(0.0, 0.0);
          }
        });
  }
}
