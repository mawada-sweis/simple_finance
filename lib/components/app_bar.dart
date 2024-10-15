import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final Function? onLeadingIconPressed;
  final bool showReturnIcon;
  final Function? onReturnPressed;
  
  const CustomeAppBar({
    super.key,
    this.title = '',
    this.leadingIcon = Icons.menu,
    this.onLeadingIconPressed,
    this.showReturnIcon = false,
    this.onReturnPressed,
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
      actions: showReturnIcon
          ? [
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  if (onReturnPressed != null) {
                    onReturnPressed!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
