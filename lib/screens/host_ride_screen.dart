// screens/host_ride_screen.dart
import 'package:flutter/material.dart';

class HostRideScreen extends StatefulWidget {
  @override
  _HostRideScreenState createState() => _HostRideScreenState();
}

class _HostRideScreenState extends State<HostRideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _vehicleType;
  int? _seats;
  double? _price;

  List<String> vehicleOptions = ['Car', 'Bike', 'Auto', 'Bus'];

  void _submitRide() {
    if (_formKey.currentState!.validate()) {
      final ride = {
        "pickup": _pickupController.text,
        "drop": _dropController.text,
        "date": _selectedDate.toString(),
        "time": _selectedTime?.format(context) ?? "",
        "vehicle": _vehicleType,
        "seats": _seats,
        "price": _price ?? 0.0,
      };
      print("Ride Hosted: $ride");

      // TODO: Send to Firestore or GCP API
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ride Hosted Successfully!")));
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Host a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _pickupController,
                decoration: InputDecoration(labelText: "Pickup Location"),
                validator: (value) =>
                    value!.isEmpty ? "Enter pickup point" : null,
              ),
              TextFormField(
                controller: _dropController,
                decoration: InputDecoration(labelText: "Drop Location"),
                validator: (value) =>
                    value!.isEmpty ? "Enter drop point" : null,
              ),
              SizedBox(height: 12),
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
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickTime,
                      child: Text(
                        _selectedTime == null
                            ? "Pick Time"
                            : _selectedTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                hint: Text("Select Vehicle Type"),
                items: vehicleOptions
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (val) => setState(() => _vehicleType = val),
                validator: (value) => value == null ? "Select a vehicle" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Number of Seats"),
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || int.tryParse(val) == null)
                    ? "Enter valid number"
                    : null,
                onChanged: (val) => _seats = int.tryParse(val),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Cost per Seat (optional)",
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => _price = double.tryParse(val),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitRide, child: Text("Host Ride")),
            ],
          ),
        ),
      ),
    );
  }
}
