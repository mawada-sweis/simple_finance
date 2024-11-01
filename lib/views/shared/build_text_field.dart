import 'package:flutter/material.dart';

class SharedTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;

  const SharedTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
