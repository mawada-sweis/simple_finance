import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final Function? onLeadingIconPressed;
  final bool showReturnIcon;
  final Function? onReturnPressed;
  final bool showEditIcon;
  final Function? onEditPressed;
  final bool isEditing;
  final bool showDeleteIcon;
  final Function? onDeletePressed;

  const CustomeAppBar({
    super.key,
    this.title = '',
    this.leadingIcon = Icons.menu,
    this.onLeadingIconPressed,
    this.showReturnIcon = false,
    this.onReturnPressed,
    this.showEditIcon = false,
    this.onEditPressed,
    this.isEditing = false,
    this.showDeleteIcon = false,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(leadingIcon ?? Icons.menu, size: 30),
        onPressed: () {
          if (onLeadingIconPressed != null) {
            onLeadingIconPressed!();
          }
        },
      ),
      title: Text(title),
      centerTitle: true,
      actions: [
        if (showEditIcon)
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (onEditPressed != null) {
                onEditPressed!();
              }
            },
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
        if (showReturnIcon)
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              if (onReturnPressed != null) {
                onReturnPressed!();
              }
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
