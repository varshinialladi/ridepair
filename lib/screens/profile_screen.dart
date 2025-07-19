import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _interestsController = TextEditingController();
  List<String> _interests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _interests = List<String>.from(doc.data()?['interests'] ?? []);
          _interestsController.text = _interests.join(', ');
        });
      }
    }
  }

  void _saveInterests() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to save interests")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final interests = _interestsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'interests': interests,
        'displayName': user.displayName ?? 'User',
        'email': user.email,
      }, SetOptions(merge: true));

      setState(() => _interests = interests);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Interests saved successfully")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving interests: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final padding = isWeb
        ? EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
            vertical: 16,
          )
        : EdgeInsets.all(16.0);

    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: padding,
              child: Column(
                children: [
                  TextField(
                    controller: _interestsController,
                    decoration: InputDecoration(
                      labelText: "Interests (comma-separated)",
                      border: OutlineInputBorder(),
                      hintText: "e.g., music, sports, travel",
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveInterests,
                    child: Text("Save Interests"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Current Interests: ${_interests.isEmpty ? 'None' : _interests.join(', ')}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _interestsController.dispose();
    super.dispose();
  }
}
