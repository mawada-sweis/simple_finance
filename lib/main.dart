import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_finance/services/product_service.dart';
import 'package:simple_finance/view_models/app_bar_view_model.dart';
import 'package:simple_finance/view_models/menu_view_model.dart';
import 'package:simple_finance/view_models/product_view_model.dart';
import 'utils/theme.dart';
import 'view_models/search_view_model.dart';
import 'views/screens/home_page_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppBarViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        Provider(create: (_) => ProductService()),
      ],
      child: MaterialApp(
        title: 'Finance App',
        theme: buildAppTheme(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'AE')],
        locale: const Locale('ar', 'AE'),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
