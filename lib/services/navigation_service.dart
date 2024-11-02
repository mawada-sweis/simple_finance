import 'package:flutter/material.dart';
import 'package:simple_finance/app_routes.dart';

class NavigationService extends ChangeNotifier {
  void navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Navigator.pushReplacementNamed(context, AppRoutes.products);
        Navigator.pushNamed(context, AppRoutes.products);
        break;
      default:
        break;
    }
  }

  void onBottomBarItemTapped(
      BuildContext context, int index, int bottomSelectedIndex) {
    if (index == bottomSelectedIndex) return;
    navigateToScreen(context, index);
  }
}
