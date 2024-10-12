import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final Function? onLeadingIconPressed;

  CustomeAppBar({this.title = '', this.leadingIcon = Icons.menu, this.onLeadingIconPressed});

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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
