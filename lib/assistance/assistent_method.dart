// import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:ridetogther/infohanddler/app_info.dart';
import 'package:ridetogther/models/directions.dart';

class AssistentMethod {
  static Future<String> searchAddressForGeographicCoordinates(
    Position position,
    BuildContext context,
  ) async {
    String humanReadableAddress = "Unknown Location";

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      humanReadableAddress =
          "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      debugPrint("Error in reverse geocoding: $e");

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationName = humanReadableAddress;
      // userPickUpAddress.locationlatitude = position.latitude;
      // userPickUpAddress.locationLongitude = position.longitude;

      //   Provider.of<AppInfo>(
      //     context,
      //     listen: false,
      //   ).updatePickupLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
}
