import 'package:flutter/material.dart';

class AddButtonComponent extends StatelessWidget {
  final VoidCallback onPressed;

  const AddButtonComponent({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add),
    );
  }
}
