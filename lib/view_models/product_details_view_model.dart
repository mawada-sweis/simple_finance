import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final Product product;
  final ProductService _productService = ProductService();
  // final AppBarViewModel appBarViewModel;
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

  // ProductDetailViewModel(this.product, this.appBarViewModel) {
  //   _initializeControllers();
  // }
  ProductDetailViewModel(this.product) {
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: product.name);
    nameController.addListener(() {
      hasChanges = true;
    });
    categoryController = TextEditingController(text: product.categoryId);
    categoryController.addListener(() {
      hasChanges = true;
    });
    colorController = TextEditingController(text: product.color);
    colorController.addListener(() {
      hasChanges = true;
    });
    purchasePriceController =
        TextEditingController(text: product.purchasePrice.toString());
    purchasePriceController.addListener(() {
      hasChanges = true;
    });
    salePriceController =
        TextEditingController(text: product.salePrice.toString());
    salePriceController.addListener(() {
      hasChanges = true;
    });
    averageCostController =
        TextEditingController(text: product.averageCost.toString());
    averageCostController.addListener(() {
      hasChanges = true;
    });
    sizeController = TextEditingController(text: product.size);
    sizeController.addListener(() {
      hasChanges = true;
    });
    stockQuantityController =
        TextEditingController(text: product.stockQuantity.toString());
    stockQuantityController.addListener(() {
      hasChanges = true;
    });
    supplierIdController = TextEditingController(text: product.supplierId);
    supplierIdController.addListener(() {
      hasChanges = true;
    });
    initialQuantityController =
        TextEditingController(text: product.initialQuantity.toString());
    initialQuantityController.addListener(() {
      hasChanges = true;
    });
    noteController = TextEditingController(text: product.note);
    noteController.addListener(() {
      hasChanges = true;
    });
  }

  Future<void> saveChanges(BuildContext context) async {
    if (hasChanges) {
      try {
        final updatedProduct = Product(
          id: product.id,
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
        );

        // Save the new Product instance to Firebase
        await _productService.updateProduct(updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
        );
        // appBarViewModel.toggleEditMode();
        // return;
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

  Future<void> deleteProduct() async {
    await _productService.deleteProduct(product.id);
  }

  void disposeControllers() {
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
  }
}
