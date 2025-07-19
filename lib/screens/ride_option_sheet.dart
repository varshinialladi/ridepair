// // screens/ride_options_sheet.dart
// import 'package:flutter/material.dart';

// enum RideType { car, bike, auto, bus }

// class RideOptionsSheet extends StatelessWidget {
//   final Function(RideType) onOptionSelected;

//   RideOptionsSheet({required this.onOptionSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Choose Ride Mode",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: RideType.values.map((type) {
//               return ElevatedButton(
//                 onPressed: () => onOptionSelected(type),
//                 child: Text(type.name.toUpperCase()),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
