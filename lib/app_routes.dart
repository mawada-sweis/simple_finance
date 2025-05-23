import 'package:flutter/material.dart';
import 'package:simple_finance/views/screens/invoice/invoice_screen.dart';
import 'package:simple_finance/views/screens/pricing/pricing_screen.dart';
import 'package:simple_finance/views/screens/transaction/transactions_screen.dart';
import 'package:simple_finance/views/screens/user/users_screen.dart';
import '../views/screens/home_page_screen.dart';
import 'views/screens/product/products_screen.dart';
import 'models/product_model.dart';

class AppRoutes {
  static const String home = '/home';
  static const String products = '/products';
  static const String users = '/users';
  static const String pricing = '/pricing';
  static const String invoice = '/invoice';
  static const String transaction = '/transaction';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    users: (context) => const UsersScreen(),
    pricing: (context) => const PricingScreen(),
    invoice: (context) => const InvoiceScreen(),
    transaction: (context) => TransactionsScreen(),
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
