import 'package:flutter/material.dart';
import 'package:simple_finance/screens/home_page_screen.dart';
import 'package:simple_finance/screens/product_screen.dart';
import '../models/product_model.dart';

// Function that generates the routes
Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => const HomeScreen(),
    '/products': (context) {
      final Map<String, dynamic> arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      List<Product> searchResults = arguments['searchResults'];
      return ProductScreen(searchResults: searchResults);
    },
  };
}
