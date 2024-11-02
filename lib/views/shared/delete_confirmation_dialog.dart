import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تأكيد الحذف'),
      content: const Text('هل أنت متأكد من أنك تريد حذف هذا العنصر؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            onConfirmDelete();
          },
          child: const Text('نعم، احذف'),
        ),
      ],
    );
  }
}
