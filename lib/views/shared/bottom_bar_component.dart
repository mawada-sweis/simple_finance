import 'package:flutter/material.dart';
import 'package:simple_finance/views/screens/home_page_screen.dart';
import '../screens/products_screen.dart';

class BottomBarComponent extends StatelessWidget {
  final int selectedIndex;

  const BottomBarComponent({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    if (index == 0) {
      // Home Icon
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      // Products Icon
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProductScreen([])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'المنتجات',
        ),
      ],
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
