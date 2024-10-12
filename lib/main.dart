import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_finance/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Finance App',
      theme: ThemeData(
        // primaryColorLight: Color.fromRGBO(33, 158, 188, 100),
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromRGBO(2, 48, 71, 1),
            onPrimary: Color(0xFFFFFFFF),
            secondary: Color.fromRGBO(251, 133, 0, 100),
            onSecondary: Color(0xFFFFFFFF),
            error: Color.fromRGBO(193, 18, 30, 1),
            onError: Color(0xFFFFFFFF),
            surface: Color.fromRGBO(247, 241, 237, 1),
            onSurface: Color(0xFF000000)),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', '')],
      locale: const Locale('ar', ''),
      home: HomeScreen(),
    );
  }
}
