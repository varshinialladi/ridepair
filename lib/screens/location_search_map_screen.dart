import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps/google_maps_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart' hide AutocompletePrediction;

class LocationSearchMapScreen extends StatefulWidget {
  const LocationSearchMapScreen({Key? key}) : super(key: key);

  @override
  _LocationSearchMapScreenState createState() =>
      _LocationSearchMapScreenState();
}

class _LocationSearchMapScreenState extends State<LocationSearchMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final List<AutocompletePrediction> _sourcePredictions = [];
  final List<AutocompletePrediction> _destinationPredictions = [];
  late GooglePlace googlePlace;
  Marker? _sourceMarker;
  Marker? _destinationMarker;

  @override
  void initState() {
    super.initState();
    String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey != null) {
      googlePlace = GooglePlace(apiKey);
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _searchPlaces(String input, bool isSource) async {
    if (input.isEmpty) {
      setState(() {
        if (isSource) {
          _sourcePredictions.clear();
        } else {
          _destinationPredictions.clear();
        }
      });
      return;
    }

    var result = await googlePlace.autocomplete.get(input);
    if (result != null && result.predictions != null) {
      setState(() {
        // if (isSource) {
        //   _sourcePredictions.clear();
        //   _sourcePredictions.addAll(result.predictions!);
        // } else {
        //   _destinationPredictions.clear();
        //   _destinationPredictions.addAll(result.predictions!);
        // }
      });
    }
  }

  void _selectPrediction(
    AutocompletePrediction prediction,
    bool isSource,
  ) async {
    var details = await googlePlace.details.get(prediction.placeId!);
    if (details != null && details.result != null) {
      double lat = details.result!.geometry!.location!.lat!;
      double lng = details.result!.geometry!.location!.lng!;
      LatLng selectedLocation = LatLng(lat, lng);

      setState(() {
        if (isSource) {
          _sourceController.text = prediction.description!;
          _sourcePredictions.clear();
          _sourceMarker = Marker(
            markerId: MarkerId("source"),
            position: selectedLocation,
            infoWindow: InfoWindow(title: "Source"),
          );
        } else {
          _destinationController.text = prediction.description!;
          _destinationPredictions.clear();
          _destinationMarker = Marker(
            markerId: MarkerId("destination"),
            position: selectedLocation,
            infoWindow: InfoWindow(title: "Destination"),
          );
        }
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocation, 14),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Location")),
      body: Stack(
        children: [
          if (_currentPosition != null)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14,
              ),
              markers: {
                if (_sourceMarker != null) _sourceMarker!,
                if (_destinationMarker != null) _destinationMarker!,
                Marker(
                  markerId: MarkerId("current"),
                  position: _currentPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                  infoWindow: InfoWindow(title: "You are here"),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                _buildSearchField(
                  "From",
                  _sourceController,
                  _sourcePredictions,
                  true,
                ),
                SizedBox(height: 10),
                _buildSearchField(
                  "To",
                  _destinationController,
                  _destinationPredictions,
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    String label,
    TextEditingController controller,
    List<AutocompletePrediction> predictions,
    bool isSource,
  ) {
    return Column(
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            controller: controller,
            onChanged: (value) => _searchPlaces(value, isSource),
            decoration: InputDecoration(
              hintText: "$label Location",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.all(10),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        if (predictions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(predictions[index].description!),
                  onTap: () => _selectPrediction(predictions[index], isSource),
                );
              },
            ),
          ),
      ],
    );
  }
}
