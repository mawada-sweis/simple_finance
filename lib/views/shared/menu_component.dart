import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/navigation_service.dart';

class MenuComponent extends StatelessWidget {
  const MenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService =
        Provider.of<NavigationService>(context, listen: false);

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
            onTap: () => navigationService.navigateToScreen(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('المنتجات', textDirection: TextDirection.rtl),
            onTap: () => navigationService.navigateToScreen(context, 1),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('الأشخاص'),
            onTap: () => navigationService.navigateToScreen(context, 2),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('التسعيرات'),
            onTap: () => navigationService.navigateToScreen(context, 3),
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('الفواتير'),
            onTap: () => navigationService.navigateToScreen(context, 4),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('الحركات'),
            onTap: () => navigationService.navigateToScreen(context, 5),
          ),
        ],
      ),
    );
  }
}
