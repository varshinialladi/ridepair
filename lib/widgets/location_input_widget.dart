// widgets/location_input_widget.dart
import 'package:flutter/material.dart';

class LocationInputWidget extends StatelessWidget {
  final String? address;
  final Function(String) onAddressSelected;

  LocationInputWidget({this.address, required this.onAddressSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final result = await showSearch(
                  context: context,
                  delegate: AddressSearchDelegate(),
                );
                if (result != null) {
                  onAddressSelected(result);
                }
              },
              child: Text(
                address ?? "Set location",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Use a placeholder delegate or real Places API integration here later.
class AddressSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = "", icon: Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, ""),
    icon: Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) =>
      ListTile(title: Text(query), onTap: () => close(context, query));

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Banjara Hills"),
          onTap: () => close(context, "Banjara Hills"),
        ),
        ListTile(
          title: Text("Kukatpally"),
          onTap: () => close(context, "Kukatpally"),
        ),
        ListTile(
          title: Text("Madhapur"),
          onTap: () => close(context, "Madhapur"),
        ),
      ],
    );
  }
}
