import 'package:flutter/material.dart';
import 'package:simple_finance/models/product_model.dart';
import 'package:simple_finance/models/user_model.dart';
import '../../models/pricing_model.dart';
import '../../services/database_service.dart';

class PricingViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Pricing> _pricing = [];
  List<Pricing> get pricing => _pricing;
  Map<String, Product> _products = {};

  PricingViewModel() {
    _fetchProducts();
  }

  void setPricing(List<Pricing> pricing) {
    _pricing = pricing;
    notifyListeners();
  }

  Future<void> fetchAllPricing() async {
    _pricing = await _databaseService.fetchAllFromCollection<Pricing>('pricing',
        fromFirestore: (data, id) => Pricing.fromFirestore(data, id));
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

  List<double> calculateTotal(Pricing pricing) {
    double total = 0.0;
    double discounts = 0.0;
    for (int i = 0; i < pricing.productsID.length; i++) {
      final productID = pricing.productsID[i];
      final discount = pricing.productDiscounts[i];
      final product = _products[productID];
      final quantity = pricing.productQuantities[i];
      if (product != null) {
        total += (product.salePrice - discount) * quantity;
        discounts += discount;
      }
    }
    return [total, discounts];
  }
}
