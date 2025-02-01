import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/pricing_model.dart';
import 'package:simple_finance/view_models/pricing/pricing_details_view_model.dart';
import 'package:simple_finance/view_models/pricing/pricing_view_model.dart';
import 'package:simple_finance/views/screens/pricing/pricing_details_screen.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/entity_card.dart';
import '../../shared/add_button_component.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  PricingScreenState createState() => PricingScreenState();
}

class PricingScreenState extends State<PricingScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final pricingViewModel =
        Provider.of<PricingViewModel>(context, listen: false);
    await pricingViewModel.fetchAllPricing();
  }

  Future<void> _navigateToPricingDetails(
      Pricing? pricing, String screenName) async {
    if (screenName != 'details' && screenName != 'add') {
      throw ArgumentError(
          'Invalid screen name: $screenName. Must be "details" or "add".');
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenName == 'details'
            ? ChangeNotifierProvider(
                create: (_) => PricingDetailsViewModel(pricing: pricing),
                child: PricingDetailsScreen(pricing: pricing!),
              )
            : ChangeNotifierProvider(
                create: (_) => PricingDetailsViewModel(
                  pricing: Pricing(
                    pricingID: '',
                    userID: '',
                    productsID: [],
                    productQuantities: [],
                    salePrice: 0.0,
                    createdDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                  ),
                ),
                child: PricingDetailsScreen(
                  pricing: Pricing(
                    pricingID: '',
                    userID: '',
                    productsID: [],
                    productQuantities: [],
                    salePrice: 0.0,
                    createdDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                  ),
                  mode: PricingMode.add,
                ),
              ),
      ),
    );

    if (result == 'updated' || result == 'deleted' || result == 'added') {
      await _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricingViewModel = Provider.of<PricingViewModel>(context);

    return MainScaffold(
      title: 'التسعيرات',
      bottomSelectedIndex: -1,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: pricingViewModel.pricing.isEmpty
                    ? const Center(child: Text("لا توجد تسعيرات لعرضها"))
                    : ListView.builder(
                        itemCount: pricingViewModel.pricing.length,
                        itemBuilder: (context, index) {
                          final pricing = pricingViewModel.pricing[index];
                          final totals =
                              pricingViewModel.calculateTotal(pricing);
                          return FutureBuilder<String>(
                            future:
                                pricingViewModel.getUserName(pricing.userID),
                            builder: (context, snapshot) {
                              String userName = snapshot.connectionState ==
                                      ConnectionState.done
                                  ? snapshot.data ?? 'غير معروف'
                                  : 'جاري التحميل...';

                              return EntityCard(
                                title: "الاسم: $userName",
                                secoundaryTitle: 'سعر البيع: ${totals[1]}',
                                additional:
                                    'التاريخ: ${pricing.createdDate.toLocal().toIso8601String().split('T')[0]}',
                                secoundaryAdditional:
                                    'الربح: ${totals[0]}',
                                onTap: () => _navigateToPricingDetails(
                                    pricing, 'details'),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: AddButtonComponent(
              onPressed: () => _navigateToPricingDetails(null, 'add'),
            ),
          ),
        ],
      ),
    );
  }
}
