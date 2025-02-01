import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/invoice_model.dart';
import 'package:simple_finance/view_models/invoice/invoice_details_view_model.dart';
import 'package:simple_finance/view_models/invoice/invoice_view_model.dart';
import 'package:simple_finance/views/screens/invoice/invoice_details_screen.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/entity_card.dart';
import '../../shared/add_button_component.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  InvoiceScreenState createState() => InvoiceScreenState();
}

class InvoiceScreenState extends State<InvoiceScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final invoiceViewModel =
        Provider.of<InvoiceViewModel>(context, listen: false);
    await invoiceViewModel.fetchAllInvoice();
  }

  Future<void> _navigateToInvoiceDetails(
      Invoice? invoice, String screenName) async {
    if (screenName != 'details' && screenName != 'add') {
      throw ArgumentError(
          'Invalid screen name: $screenName. Must be "details" or "add".');
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenName == 'details'
            ? ChangeNotifierProvider(
                create: (_) => InvoiceDetailsViewModel(invoice: invoice),
                child: InvoiceDetailsScreen(invoice: invoice!),
              )
            : ChangeNotifierProvider(
                create: (_) => InvoiceDetailsViewModel(
                  invoice: Invoice(
                    invoiceID: '',
                    userID: '',
                    productsID: [],
                    productQuantities: [],
                    productDiscounts: [],
                    createdDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                  ),
                ),
                child: InvoiceDetailsScreen(
                  invoice: Invoice(
                    invoiceID: '',
                    userID: '',
                    productsID: [],
                    productQuantities: [],
                    productDiscounts: [],
                    createdDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                  ),
                  mode: InvoiceMode.add,
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
    final invoiceViewModel = Provider.of<InvoiceViewModel>(context);

    return MainScaffold(
      title: 'الفواتير',
      bottomSelectedIndex: -1,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: invoiceViewModel.invoice.isEmpty
                    ? const Center(child: Text("لا توجد فواتير لعرضها"))
                    : ListView.builder(
                        itemCount: invoiceViewModel.invoice.length,
                        itemBuilder: (context, index) {
                          final invoice = invoiceViewModel.invoice[index];
                          final totals =
                              invoiceViewModel.calculateTotal(invoice);
                          return FutureBuilder<String>(
                            future:
                                invoiceViewModel.getUserName(invoice.userID),
                            builder: (context, snapshot) {
                              String userName = snapshot.connectionState ==
                                      ConnectionState.done
                                  ? snapshot.data ?? 'غير معروف'
                                  : 'جاري التحميل...';

                              return EntityCard(
                                title: "الاسم: $userName",
                                secoundaryTitle: 'المجموع: ${totals[0]}',
                                additional:
                                    'التاريخ: ${invoice.createdDate.toLocal().toIso8601String().split('T')[0]}',
                                secoundaryAdditional:
                                    'مجموع الخصم: ${totals[1]}',
                                onTap: () => _navigateToInvoiceDetails(
                                    invoice, 'details'),
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
              onPressed: () => _navigateToInvoiceDetails(null, 'add'),
            ),
          ),
        ],
      ),
    );
  }
}
