import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/app_bar_view_model.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showReturnIcon;
  final bool showEditIcon;
  final bool showDeleteIcon;
  final Function? onDeletePressed;
  final VoidCallback? onSavePressed;

  const AppBarComponent({
    super.key,
    required this.title,
    this.showReturnIcon = true,
    this.showEditIcon = false,
    this.showDeleteIcon = false,
    this.onDeletePressed,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    final appBarViewModel = Provider.of<AppBarViewModel>(context);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, size: 25),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        if (showEditIcon)
          IconButton(
            icon: Icon(appBarViewModel.isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (appBarViewModel.isEditing && onSavePressed != null) {
                onSavePressed!();
              } else {
                appBarViewModel.toggleEditMode();
              }
            },
          ),
        if (showDeleteIcon)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDeletePressed?.call(),
          ),
        if (showReturnIcon)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
