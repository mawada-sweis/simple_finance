import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/view_models/product/product_details_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/build_text_field.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addProductViewModel = Provider.of<ProductDetailViewModel>(context);

    return MainScaffold(
      title: 'إضافة منتج',
      bottomSelectedIndex: 0,
      showSaveIcon: true,
      onSavePressed: () async {
        await addProductViewModel.addProduct(context);
        Navigator.pop(context, 'added');
      },
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SharedTextField(
              label: 'الاسم',
              controller: addProductViewModel.nameController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'التصنيف',
              controller: addProductViewModel.categoryController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'اللون',
              controller: addProductViewModel.colorController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'سعر الشراء',
              controller: addProductViewModel.purchasePriceController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'سعر البيع',
              controller: addProductViewModel.salePriceController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'الحجم',
              controller: addProductViewModel.sizeController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'كمية المخزون',
              controller: addProductViewModel.stockQuantityController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'الوحدة',
              controller: addProductViewModel.unitController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'متوسط الشراء',
              controller: addProductViewModel.averageCostController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'آخر سعر شراء',
              controller: addProductViewModel.lastPurchasePriceController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'الكمية الأولية',
              controller: addProductViewModel.initialQuantityController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'رقم المورد',
              controller: addProductViewModel.supplierIdController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'الملاحظات',
              controller: addProductViewModel.noteController,
              readOnly: false,
            ),
          ],
        ),
      ),
    );
  }
}
