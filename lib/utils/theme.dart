import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromRGBO(2, 48, 71, 1),
      onPrimary: Colors.white,
      secondary: Color.fromRGBO(251, 133, 0, 100),
      onSecondary: Colors.black,
      surface: Color.fromRGBO(247, 241, 237, 1),
      onSurface: Colors.black,
      error: Color.fromRGBO(193, 18, 30, 1),
      onError: Colors.white,
      primaryContainer: Color.fromRGBO(33, 157, 188, 1),
      secondaryContainer: Color.fromRGBO(251, 133, 0, 1),
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color.fromRGBO(2, 48, 71, 1),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      showUnselectedLabels: true,
    ),
  );
}
