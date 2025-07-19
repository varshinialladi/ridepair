import 'package:flutter/material.dart';

class MyTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    // primarySwatch: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
  );
}
