import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../models/pricing_model.dart';
import '../../models/user_model.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import 'product_selection_component.dart';

class PricingDetailsViewModel extends ChangeNotifier {
  var logger = Logger();
  final DatabaseService _databaseService = DatabaseService();
  final Pricing pricing;

  String pricingID = '';
  String? selectedUserID;
  double totalPurchasePrice = 0.0;
  double salePrice = 0.0;
  double total = 0.0;
  bool isLoading = true;

  List<ProductSelectionData> productSelections = [];
  List<User> userOptions = [];
  List<Product> productOptions = [];
  List<User> filteredUserOptions = [];

  PricingDetailsViewModel({required this.pricing}) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      pricingID = await _generatePricingID();
      await _fetchUserOptions();
      await _fetchProductOptions();
      filteredUserOptions = List.from(userOptions);
      _initializeFields();
    } catch (e) {
      logger.e('Error initializing PricingDetailsViewModel: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetFields() {
    selectedUserID = null;
    totalPurchasePrice = 0.0;
    total = 0.0;
    productSelections.clear();
    notifyListeners();
  }

  void updateSalePrice(double newPrice) {
    salePrice = newPrice;
    _calculateTotals();
    notifyListeners();
  }

  Future<String> _generatePricingID() async {
    final nextID = await _databaseService.getLastDocID('pricing');
    String currentID = nextID != null ? nextID.padLeft(3, '0') : '000';
    return currentID;
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
    salePrice = pricing.salePrice;
    productSelections = List.generate(pricing.productsID.length, (index) {
      final productID = pricing.productsID[index];
      final quantity = pricing.productQuantities[index];
      final product = productOptions.firstWhere((p) => p.id == productID);

      return ProductSelectionData(
        productID: product.id,
        productName: product.name,
        purchasePrice: product.purchasePrice,
        quantity: quantity,
        total: product.purchasePrice * quantity,
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

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUserOptions = List.from(userOptions);
    } else {
      filteredUserOptions = userOptions
          .where((user) =>
              user.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetUserOptions() {
    filteredUserOptions = List.from(userOptions);
    notifyListeners();
  }

  void addProductRow() {
    productSelections.add(ProductSelectionData(
      productID: '',
      productName: '',
      purchasePrice: 0.0,
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
    totalPurchasePrice = 0.0;
    for (var product in productSelections) {
      totalPurchasePrice += product.total;
    }
    total = salePrice - totalPurchasePrice;
  }

  Future<void> updatePricing(BuildContext context) async {
    if (selectedUserID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب اختيار اسم الشخص'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else if (productSelections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب اختيار منتج واحد على الأقل'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    pricing.userID = selectedUserID!;
    pricing.productsID = productSelections.map((p) => p.productID).toList();
    pricing.productQuantities =
        productSelections.map((p) => p.quantity).toList();
    pricing.updatedDate = DateTime.now();

    await _databaseService.updatePricing(pricing);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
    );
  }

  Future<void> savePricing(BuildContext context) async {
    if (selectedUserID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب اختيار اسم الشخص'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else if (productSelections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب اختيار منتج واحد على الأقل'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final newPricing = Pricing(
      pricingID: pricingID,
      userID: selectedUserID!,
      productsID: productSelections.map((p) => p.productID).toList(),
      productQuantities: productSelections.map((p) => p.quantity).toList(),
      salePrice: salePrice,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );

    await _databaseService.addPricing(newPricing);
    resetFields();
    notifyListeners();
  }
}
