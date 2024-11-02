import 'package:flutter/material.dart';
import 'package:simple_finance/services/database_service.dart';
import '../../models/product_model.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final Product? product;
  final DatabaseService _databaseService = DatabaseService();
  bool hasChanges = false;

  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController colorController;
  late TextEditingController purchasePriceController;
  late TextEditingController salePriceController;
  late TextEditingController averageCostController;
  late TextEditingController sizeController;
  late TextEditingController stockQuantityController;
  late TextEditingController supplierIdController;
  late TextEditingController initialQuantityController;
  late TextEditingController noteController;
  late TextEditingController unitController;
  late TextEditingController lastPurchasePriceController;

  ProductDetailViewModel({this.product}) {
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: product?.name ?? '');
    categoryController = TextEditingController(text: product?.categoryId ?? '');
    colorController = TextEditingController(text: product?.color ?? '');
    purchasePriceController =
        TextEditingController(text: product?.purchasePrice.toString() ?? '');
    salePriceController =
        TextEditingController(text: product?.salePrice.toString() ?? '');
    averageCostController =
        TextEditingController(text: product?.averageCost.toString() ?? '');
    sizeController = TextEditingController(text: product?.size ?? '');
    stockQuantityController =
        TextEditingController(text: product?.stockQuantity.toString() ?? '');
    supplierIdController =
        TextEditingController(text: product?.supplierId ?? '');
    initialQuantityController =
        TextEditingController(text: product?.initialQuantity.toString() ?? '');
    noteController = TextEditingController(text: product?.note ?? '');
    lastPurchasePriceController = TextEditingController(
        text: product?.lastPurchasePrice.toString() ?? '');
    unitController = TextEditingController(text: product?.unit ?? '');
    _addChangeListeners();
  }

  void _addChangeListeners() {
    nameController.addListener(() => hasChanges = true);
    categoryController.addListener(() => hasChanges = true);
    colorController.addListener(() => hasChanges = true);
    purchasePriceController.addListener(() => hasChanges = true);
    salePriceController.addListener(() => hasChanges = true);
    averageCostController.addListener(() => hasChanges = true);
    sizeController.addListener(() => hasChanges = true);
    stockQuantityController.addListener(() => hasChanges = true);
    supplierIdController.addListener(() => hasChanges = true);
    initialQuantityController.addListener(() => hasChanges = true);
    noteController.addListener(() => hasChanges = true);
    lastPurchasePriceController.addListener(() => hasChanges = true);
    unitController.addListener(() => hasChanges = true);
  }

  Future<void> saveChanges(BuildContext context) async {
    if (product != null && hasChanges) {
      try {
        final updatedProduct = Product(
          id: product!.id,
          name: nameController.text,
          categoryId: categoryController.text,
          color: colorController.text,
          purchasePrice: double.parse(purchasePriceController.text),
          salePrice: double.parse(salePriceController.text),
          averageCost: double.parse(averageCostController.text),
          size: sizeController.text,
          stockQuantity: int.parse(stockQuantityController.text),
          supplierId: supplierIdController.text,
          initialQuantity: int.parse(initialQuantityController.text),
          note: noteController.text,
          unit: unitController.text,
          lastPurchasePrice: double.parse(lastPurchasePriceController.text),
        );

        await _databaseService.updateProduct(updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
        );
        hasChanges = false;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في حفظ التغييرات')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد تغييرات لحفظها')),
      );
    }
  }

  Future<void> addProduct(BuildContext context) async {
    try {
      final newProduct = Product(
        id: '',
        name: nameController.text,
        categoryId: categoryController.text,
        color: colorController.text,
        purchasePrice: double.tryParse(purchasePriceController.text) ?? 0.0,
        salePrice: double.tryParse(salePriceController.text) ?? 0.0,
        averageCost: double.tryParse(averageCostController.text) ?? 0.0,
        size: sizeController.text,
        stockQuantity: int.tryParse(stockQuantityController.text) ?? 0,
        supplierId: supplierIdController.text,
        initialQuantity: int.tryParse(initialQuantityController.text) ?? 0,
        note: noteController.text,
        lastPurchasePrice:
            double.tryParse(lastPurchasePriceController.text) ?? 0.0,
        unit: unitController.text,
      );

      await _databaseService.addProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المنتج بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إضافة المنتج')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    colorController.dispose();
    purchasePriceController.dispose();
    salePriceController.dispose();
    averageCostController.dispose();
    sizeController.dispose();
    stockQuantityController.dispose();
    supplierIdController.dispose();
    initialQuantityController.dispose();
    noteController.dispose();
    lastPurchasePriceController.dispose();
    unitController.dispose();
    super.dispose();
  }
}
