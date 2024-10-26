import 'package:flutter/material.dart';
import '../views/screens/home_page_screen.dart';
import '../views/screens/products_screen.dart';

class MenuViewModel extends ChangeNotifier {
  void navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProductScreen([])),
        );
        break;
      default:
        break;
    }
  }
}
