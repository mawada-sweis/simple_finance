import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product_model.dart';
import '../../../view_models/product/product_details_view_model.dart';
import '../../../view_models/app_bar_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/build_text_field.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appBarViewModel = Provider.of<AppBarViewModel>(context, listen: true);

    return ChangeNotifierProvider(
      create: (_) => ProductDetailViewModel(product: product),
      child: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          return MainScaffold(
            title: 'معلومات المنتج',
            showEditIcon: true,
            showDeleteIcon: true,
            bottomSelectedIndex: 1,
            onSavePressed: () async {
              await viewModel.saveChanges(context);
              appBarViewModel.toggleEditMode();
              Navigator.pop(context, 'updated');
            },
            deleteDocInfo: ['products', product.id],
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SharedTextField(
                    label: 'الاسم',
                    controller: viewModel.nameController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'التصنيف',
                    controller: viewModel.categoryController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'اللون',
                    controller: viewModel.colorController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'سعر الشراء',
                    controller: viewModel.purchasePriceController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'سعر البيع',
                    controller: viewModel.salePriceController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'متوسط التكلفة',
                    controller: viewModel.averageCostController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'الحجم',
                    controller: viewModel.sizeController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'كمية المخزون',
                    controller: viewModel.stockQuantityController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'رقم المورد',
                    controller: viewModel.supplierIdController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'الكمية الأولية',
                    controller: viewModel.initialQuantityController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'الوحدة',
                    controller: viewModel.unitController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'آخر سعر شراء',
                    controller: viewModel.lastPurchasePriceController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'الملاحظات',
                    controller: viewModel.noteController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
