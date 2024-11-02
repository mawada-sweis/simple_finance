import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/navigation_service.dart';
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
  final List<String>? deleteDocInfo;
  final VoidCallback? onSavePressed;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.bottomSelectedIndex,
    this.showReturnIcon = true,
    this.showEditIcon = false,
    this.showDeleteIcon = false,
    this.deleteDocInfo,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    final navigationService =
        Provider.of<NavigationService>(context, listen: false);

    return Scaffold(
      appBar: AppBarComponent(
        title: title,
        showReturnIcon: showReturnIcon,
        showEditIcon: showEditIcon,
        showDeleteIcon: showDeleteIcon,
        deleteDocInfo: deleteDocInfo,
        onSavePressed: onSavePressed,
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: const Drawer(
          child: MenuComponent(),
        ),
      ),
      body: body,
      bottomNavigationBar: BottomBarComponent(
          selectedIndex: bottomSelectedIndex,
          onItemTapped: (index) => navigationService.onBottomBarItemTapped(
              context, index, bottomSelectedIndex)),
    );
  }
}
