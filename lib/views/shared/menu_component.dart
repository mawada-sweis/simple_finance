import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/menu_view_model.dart';

class MenuComponent extends StatelessWidget {
  const MenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final menuViewModel = Provider.of<MenuViewModel>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Text(
                'القائمة الرئيسية',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('الرئيسية', textDirection: TextDirection.rtl),
            onTap: () => menuViewModel.navigateToScreen(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('المنتجات', textDirection: TextDirection.rtl),
            onTap: () => menuViewModel.navigateToScreen(context, 1),
          ),
        ],
      ),
    );
  }
}
