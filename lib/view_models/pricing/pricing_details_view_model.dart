import 'package:flutter/material.dart';
import '../../models/pricing_model.dart';
import '../../models/user_model.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import '../../views/shared/product_selection_component.dart';

class PricingDetailsViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final Pricing pricing;

  String? selectedUserID;
  double totalSalesPrice = 0.0;
  double totalDiscount = 0.0;

  List<ProductSelectionData> productSelections = [];
  List<User> userOptions = [];
  List<Product> productOptions = [];

  PricingDetailsViewModel({required this.pricing}) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchUserOptions();
    await _fetchProductOptions();
    _initializeFields();
  }

  Future<void> _fetchUserOptions() async {
    userOptions = await _databaseService.fetchAllFromCollection<User>(
      'users',
      fromFirestore: (data, id) => User(
        id: id,
        fullName: data['full_name'] ?? '',
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        role: data['role'] ?? '',
      ),
    );
    notifyListeners();
  }

  Future<void> _fetchProductOptions() async {
    productOptions = await _databaseService.fetchAllFromCollection<Product>(
      'products',
      fromFirestore: (data, id) => Product.fromFirestore(data, id),
    );
    notifyListeners();
  }

  void _initializeFields() {
    selectedUserID = pricing.userID;

    productSelections = List.generate(pricing.productsID.length, (index) {
      final productID = pricing.productsID[index];
      final discount = pricing.productDiscounts[index];
      final quantity = pricing.productQuantities[index];

      final product = productOptions.firstWhere((p) => p.id == productID);

      return ProductSelectionData(
        productID: product.id,
        productName: product.name,
        purchasePrice: product.purchasePrice,
        salePrice: product.salePrice,
        discount: discount,
        quantity: quantity,
        total: (product.salePrice - discount) * quantity,
      );
    });

    _calculateTotals();
  }

  String getUserNameByID(String? userID) {
    if (userID == null) return 'غير معروف';
    return userOptions
        .firstWhere((u) => u.id == userID,
            orElse: () => User(
                id: '',
                fullName: 'غير معروف',
                address: '',
                phone: '',
                role: ''))
        .fullName;
  }

  void setUserID(String userID) {
    selectedUserID = userID;
    notifyListeners();
  }

  void addProductRow() {
    productSelections.add(ProductSelectionData(
      productID: '',
      productName: '',
      purchasePrice: 0.0,
      salePrice: 0.0,
      discount: 0.0,
      quantity: 1,
      total: 0.0,
    ));
    notifyListeners();
  }

  void updateProductData(int index, ProductSelectionData data) {
    productSelections[index] = data;
    _calculateTotals();
    notifyListeners();
  }

  void removeProductRow(int index) {
    productSelections.removeAt(index);
    _calculateTotals();
    notifyListeners();
  }

  void _calculateTotals() {
    totalSalesPrice = 0.0;
    totalDiscount = 0.0;
    for (var product in productSelections) {
      totalSalesPrice += product.total;
      totalDiscount += product.discount;
    }
  }

  Future<void> savePricing(BuildContext context) async {
    pricing.userID = selectedUserID!;
    pricing.productsID = productSelections.map((p) => p.productID).toList();
    pricing.productQuantities =
        productSelections.map((p) => p.quantity).toList();
    pricing.productDiscounts =
        productSelections.map((p) => p.discount).toList();
    pricing.updatedDate = DateTime.now();

    await _databaseService.updatePricing(pricing);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
    );
  }
}
