import 'package:flutter/material.dart';
import 'package:simple_finance/services/database_service.dart';
import '../../models/pricing_model.dart';
import '../../models/user_model.dart';
import '../../models/product_model.dart';
import '../../views/shared/product_selection_component.dart';
import 'package:logger/logger.dart';

class AddPricingViewModel extends ChangeNotifier {
  var logger = Logger();
  final DatabaseService _databaseService = DatabaseService();
  String pricingID = '';
  TextEditingController notesController = TextEditingController();
  DateTime createdDate = DateTime.now();
  String? selectedUserID;
  double totalSalesPrice = 0.0;
  double totalDiscount = 0.0;
  bool isLoading = true;
  List<ProductSelectionData> productSelections = [];

  List<User> userOptions = [];
  List<Product> productOptions = [];

  AddPricingViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      resetFields();
      pricingID = await _generatePricingID();
      await _fetchUserOptions();
      await _fetchProductOptions();
      resetFields();
    } catch (e) {
      logger.e('Error initializing AddPricingViewModel: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _generatePricingID() async {
    final nextID = await _databaseService.getLastPricingID();
    String currentID = nextID != null ? nextID.padLeft(3, '0') : '000';
    return currentID;
  }

  Future<void> _fetchUserOptions() async {
    userOptions = await _databaseService.fetchAllFromCollection<User>('users',
        fromFirestore: (data, id) => User(
            id: id,
            fullName: data['full_name'] ?? '',
            address: data['address'] ?? '',
            phone: data['phone'] ?? '',
            role: data['role'] ?? ''));
    notifyListeners();
  }

  Future<void> _fetchProductOptions() async {
    productOptions = await _databaseService.fetchAllFromCollection<Product>(
        'products',
        fromFirestore: (data, id) => Product.fromFirestore(data, id));
    notifyListeners();
  }

  void resetFields() {
    notesController.clear();
    selectedUserID = null;
    productSelections.clear();
    totalSalesPrice = 0.0;
    totalDiscount = 0.0;
    notifyListeners();
  }

  void setUserID(String userID) {
    selectedUserID = userID;
    notifyListeners();
  }

  void addProductEntry() {
    productSelections.add(ProductSelectionData(
      productID: '',
      productName: '',
      purchasePrice: 0.0,
      salePrice: 0.0,
      quantity: 1,
      discount: 0.0,
      total: 0.0,
    ));
    notifyListeners();
    _calculateTotals();
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
      productDiscounts: productSelections.map((p) => p.discount).toList(),
      createdDate: createdDate,
      updatedDate: DateTime.now(),
    );

    await _databaseService.addPricing(newPricing);
    resetFields();
    notifyListeners();
  }
}
