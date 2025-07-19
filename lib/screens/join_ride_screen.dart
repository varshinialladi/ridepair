// screens/join_ride_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinRideScreen extends StatefulWidget {
  @override
  _JoinRideScreenState createState() => _JoinRideScreenState();
}

class _JoinRideScreenState extends State<JoinRideScreen> {
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _mockRides =
      []; // Later fetched from GCP/Firestore
  List<Map<String, dynamic>> _filteredRides = [];

  get ride => null;

  void _searchRides() {
    setState(() {
      _filteredRides = _mockRides.where((ride) {
        final fromPlace =
            ride['from_location']['place']?.toString().toLowerCase() ?? '';
        final toPlace =
            ride['to_location']['place']?.toString().toLowerCase() ?? '';
        final rideDate = ride['departure_time']?.toString().split(
          "T",
        )[0]; // ISO string
        final selectedDateStr = _selectedDate?.toIso8601String().split("T")[0];

        return fromPlace.contains(_pickupController.text.toLowerCase()) &&
            toPlace.contains(_dropController.text.toLowerCase()) &&
            rideDate == selectedDateStr;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMockRides();
  }

  void _loadMockRides() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('hosted_rides')
        .get();

    setState(() {
      _mockRides = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> sendRideRequest(Map<String, dynamic> ride) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final requestData = {
      'rider_uid': currentUser.uid,
      'from_location': ride['from_location'],
      'to_location': ride['to_location'],
      'vehicle_preference': ride['vehicle_type'],
      'time_flex_minutes': 15, // you can customize this
      'interests': [], // or fetch from user profile if needed
      'requested_at': Timestamp.now(),
      'host_uid': ride['host_uid'],
      'ride_id': ride['ride_id'], // optional, if ride has docID
    };

    await FirebaseFirestore.instance
        .collection('ride_requests')
        .add(requestData);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Join a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(labelText: "Pickup Location"),
            ),
            TextField(
              controller: _dropController,
              decoration: InputDecoration(labelText: "Drop Location"),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate == null
                          ? "Pick Date"
                          : _selectedDate.toString().split(" ")[0],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchRides,
                  child: Text("Search Rides"),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _filteredRides.isEmpty
                  ? Center(child: Text("No rides found."))
                  : ListTile(
                      title: Text(
                        "${ride['from_location']['place']} ➜ ${ride['to_location']['place']}",
                      ),
                      subtitle: Text(
                        "${ride['departure_time']} | ${ride['vehicle_type']} | Seats: ${ride['seats_available']}",
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await sendRideRequest(ride);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Ride request sent")),
                          );
                        },
                        child: Text("Join"),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
