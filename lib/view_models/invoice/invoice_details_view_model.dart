import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simple_finance/models/invoice_model.dart';
import '../../models/user_model.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import '../../views/shared/product_selection_component.dart';

class InvoiceDetailsViewModel extends ChangeNotifier {
  var logger = Logger();
  final DatabaseService _databaseService = DatabaseService();
  final Invoice invoice;

  String invoiceID = '';
  String? selectedUserID;
  double totalSalesPrice = 0.0;
  double totalDiscount = 0.0;
  bool isLoading = true;

  List<ProductSelectionData> productSelections = [];
  List<User> userOptions = [];
  List<Product> productOptions = [];
  List<User> filteredUserOptions = [];

  InvoiceDetailsViewModel({required this.invoice}) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      invoiceID = await _generateInvoiceID();
      await _fetchUserOptions();
      await _fetchProductOptions();
      filteredUserOptions = List.from(userOptions);
      _initializeFields();
    } catch (e) {
      logger.e('Error initializing InvoiceDetailsViewModel: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetFields() {
    selectedUserID = null;
    totalSalesPrice = 0.0;
    totalDiscount = 0.0;
    productSelections.clear();
    notifyListeners();
  }

  Future<String> _generateInvoiceID() async {
    final nextID = await _databaseService.getLastDocID('invoice');
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
    selectedUserID = invoice.userID;

    productSelections = List.generate(invoice.productsID.length, (index) {
      final productID = invoice.productsID[index];
      final discount = invoice.productDiscounts[index];
      final quantity = invoice.productQuantities[index];

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

  Future<void> updateInvoice(BuildContext context) async {
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
    invoice.userID = selectedUserID!;
    invoice.productsID = productSelections.map((p) => p.productID).toList();
    invoice.productQuantities =
        productSelections.map((p) => p.quantity).toList();
    invoice.productDiscounts =
        productSelections.map((p) => p.discount).toList();
    invoice.updatedDate = DateTime.now();

    await _databaseService.updateInvoice(invoice);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
    );
  }

  Future<void> saveInvoice(BuildContext context) async {
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

    final newInvoice = Invoice(
      invoiceID: invoiceID,
      userID: selectedUserID!,
      productsID: productSelections.map((p) => p.productID).toList(),
      productQuantities: productSelections.map((p) => p.quantity).toList(),
      productDiscounts: productSelections.map((p) => p.discount).toList(),
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );

    await _databaseService.addInvoice(newInvoice);
    resetFields();
    notifyListeners();
  }
}
