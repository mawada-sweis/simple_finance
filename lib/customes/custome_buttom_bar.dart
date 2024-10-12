import 'package:flutter/material.dart';
import 'package:simple_finance/home_screen.dart';

class CustomBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: IconButton(
        icon: const Icon(
          Icons.home,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
    );
  }
}
