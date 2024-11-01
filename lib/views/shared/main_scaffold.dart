import 'package:flutter/material.dart';
import './app_bar_component.dart';
import './menu_component.dart';
import './bottom_bar_component.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int bottomSelectedIndex;
  final bool showReturnIcon;
  final bool showEditIcon;
  final bool showDeleteIcon;
  final Function? onDeletePressed;
  final VoidCallback? onSavePressed;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottomSelectedIndex = 0,
    this.showReturnIcon = true,
    this.showEditIcon = false,
    this.showDeleteIcon = false,
    this.onDeletePressed,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        title: title,
        showReturnIcon: showReturnIcon,
        showEditIcon: showEditIcon,
        showDeleteIcon: showDeleteIcon,
        onDeletePressed: onDeletePressed,
        onSavePressed: onSavePressed,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: const Drawer(
          child: MenuComponent(),
        ),
      ),
      body: body,
      bottomNavigationBar:
          BottomBarComponent(selectedIndex: bottomSelectedIndex),
    );
  }
}
