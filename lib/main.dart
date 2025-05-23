import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_finance/app_routes.dart';
import 'package:simple_finance/models/invoice_model.dart';
import 'package:simple_finance/models/pricing_model.dart';
import 'package:simple_finance/services/navigation_service.dart';
import 'package:simple_finance/view_models/app_bar_view_model.dart';
import 'package:simple_finance/view_models/invoice/invoice_details_view_model.dart';
import 'package:simple_finance/view_models/invoice/invoice_view_model.dart';
import 'package:simple_finance/view_models/pricing/pricing_details_view_model.dart';
import 'package:simple_finance/view_models/pricing/pricing_view_model.dart';
import 'package:simple_finance/view_models/product/product_details_view_model.dart';
import 'package:simple_finance/view_models/product/product_view_model.dart';
import 'package:simple_finance/view_models/transaction/transaction_view_model.dart';
import 'package:simple_finance/view_models/user/users_view_model.dart';
import 'utils/theme.dart';
import 'view_models/search_view_model.dart';
import 'package:provider/provider.dart';

import 'view_models/user/user_details_view_model.dart';

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
        ChangeNotifierProvider(create: (_) => NavigationService()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => UsersViewModel()),
        ChangeNotifierProvider(create: (_) => UserDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => ProductDetailViewModel()),
        ChangeNotifierProvider(create: (_) => PricingViewModel()),
        ChangeNotifierProvider(create: (_) => PricingDetailsViewModel(pricing: Pricing as Pricing)),
        ChangeNotifierProvider(create: (_) => InvoiceViewModel()),
        ChangeNotifierProvider(create: (_) => InvoiceDetailsViewModel(invoice: Invoice as Invoice)),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
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
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
