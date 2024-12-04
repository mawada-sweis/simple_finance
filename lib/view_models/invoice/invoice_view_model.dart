import 'package:flutter/material.dart';
import 'package:simple_finance/models/invoice_model.dart';
import 'package:simple_finance/models/product_model.dart';
import 'package:simple_finance/models/user_model.dart';
import '../../services/database_service.dart';

class InvoiceViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Invoice> _invoice = [];
  List<Invoice> get invoice => _invoice;
  Map<String, Product> _products = {};

  InvoiceViewModel() {
    _fetchProducts();
  }

  void setInvoice(List<Invoice> invoice) {
    _invoice = invoice;
    notifyListeners();
  }

  Future<void> fetchAllInvoice() async {
    _invoice = await _databaseService.fetchAllFromCollection<Invoice>('invoice',
        fromFirestore: (data, id) => Invoice.fromFirestore(data, id));
    notifyListeners();
  }

  Future<void> _fetchProducts() async {
    List<Product> products =
        await _databaseService.fetchAllFromCollection<Product>('products',
            fromFirestore: (data, id) => Product.fromFirestore(data, id));

    _products = {for (var product in products) product.id: product};
    notifyListeners();
  }

  Future<String> getUserName(String userID) async {
    User? user = await _databaseService.getDocByID<User>(
      'users',
      userID,
      (data, id) => User(
          id: id,
          fullName: data['full_name'] ?? '',
          address: data['address'] ?? '',
          phone: data['phone'] ?? '',
          role: data['role'] ?? ''),
    );
    return user?.fullName ?? 'Unknown';
  }

  List<double> calculateTotal(Invoice invoice) {
    double total = 0.0;
    double discounts = 0.0;
    for (int i = 0; i < invoice.productsID.length; i++) {
      final productID = invoice.productsID[i];
      final discount = invoice.productDiscounts[i];
      final product = _products[productID];
      final quantity = invoice.productQuantities[i];
      if (product != null) {
        total += (product.salePrice - discount) * quantity;
        discounts += discount;
      }
    }
    return [total, discounts];
  }
}
