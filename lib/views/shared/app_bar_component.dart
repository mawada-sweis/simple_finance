import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/app_bar_view_model.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showReturnIcon;
  final bool showEditIcon;
  final bool showDeleteIcon;
  final Function? onDeletePressed;

  const AppBarComponent({
    super.key,
    this.title = '',
    this.showReturnIcon = true,
    this.showEditIcon = false,
    this.showDeleteIcon = false,
    this.onDeletePressed,
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
        if (showReturnIcon)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        if (showEditIcon)
          IconButton(
            icon: Icon(appBarViewModel.isEditing ? Icons.save : Icons.edit),
            onPressed: () => appBarViewModel.toggleEditMode(),
          ),
        if (showDeleteIcon)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (onDeletePressed != null) {
                onDeletePressed!();
              }
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
