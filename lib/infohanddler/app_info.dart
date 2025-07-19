import 'package:flutter/material.dart';
import 'package:ridetogther/models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickupLocation, userDropoffLocation;
  int countTotalTrips = 0;
  //List<String> historyTrips = [];
  // List<TripsHistoryMdel> alltripsHistoryInformation = [];

  void updatePickupLocationAddress(Directions userPickUpAddress) {
    userPickupLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropoffLocationAddress(Directions userDropOffAddress) {
    userDropoffLocation = userDropOffAddress;
    notifyListeners();
  }
}
