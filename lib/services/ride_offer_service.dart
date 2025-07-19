import 'package:cloud_firestore/cloud_firestore.dart';

class RideOfferService {
  static Future<List<Map<String, dynamic>>> fetchRideOffers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ride_offers')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
