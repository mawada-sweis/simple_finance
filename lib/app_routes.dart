import 'package:flutter/material.dart';
import 'package:simple_finance/views/screens/user/users_screen.dart';
import '../views/screens/home_page_screen.dart';
import 'views/screens/product/products_screen.dart';
import 'models/product_model.dart';

class AppRoutes {
  static const String home = '/home';
  static const String products = '/products';
  static const String users = '/users';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    users: (context) => const UsersScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case products:
        final results = settings.arguments as List<Product>?;
        return MaterialPageRoute(
          builder: (context) => ProductScreen(searchResults: results ?? []),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
    }
  }
}
