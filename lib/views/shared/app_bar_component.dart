import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/app_bar_view_model.dart';
import './delete_confirmation_dialog.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showReturnIcon;
  final bool showEditIcon;
  final bool showDeleteIcon;
  final List<String>? deleteDocInfo;
  final VoidCallback? onSavePressed;

  const AppBarComponent({
    super.key,
    required this.title,
    this.showReturnIcon = true,
    this.showEditIcon = false,
    this.showDeleteIcon = false,
    this.deleteDocInfo,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    final appBarViewModel = Provider.of<AppBarViewModel>(context);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext innerContext) {
          return IconButton(
            icon: const Icon(Icons.menu, size: 25),
            onPressed: () => Scaffold.of(innerContext).openDrawer(),
          );
        },
      ),
      actions: [
        if (showEditIcon)
          IconButton(
            icon: Icon(appBarViewModel.isEditing ? Icons.save : Icons.edit),
            onPressed: () => appBarViewModel.handleEditSave(onSavePressed),
          ),
        if (showDeleteIcon)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context, appBarViewModel);
            },
          ),
        if (showReturnIcon)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => appBarViewModel.handleReturn(context),
          ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, AppBarViewModel appBarViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(
          onConfirmDelete: () async {
            Navigator.pop(dialogContext);
            await appBarViewModel.deleteDocument(deleteDocInfo);
            Navigator.pop(context, "deleted");
          },
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
