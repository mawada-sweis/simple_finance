import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/user_model.dart';
import 'package:simple_finance/view_models/app_bar_view_model.dart';
import '../../../models/pricing_model.dart';
import '../../../view_models/pricing/pricing_details_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/product_selection_component.dart';

class PricingDetailsScreen extends StatelessWidget {
  final Pricing pricing;

  const PricingDetailsScreen({super.key, required this.pricing});

  @override
  Widget build(BuildContext context) {
    final appBarViewModel =
        Provider.of<AppBarViewModel>(context, listen: false);

    // Reset edit mode when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appBarViewModel.resetEditMode();
    });
    return Consumer<AppBarViewModel>(
      builder: (context, appBarViewModel, child) {
        return MainScaffold(
          title: 'تفاصيل التسعير',
          showEditIcon: true,
          showDeleteIcon: true,
          bottomSelectedIndex: -1,
          onSavePressed: () async {
            if (appBarViewModel.isEditing) {
              await Provider.of<PricingDetailsViewModel>(context, listen: false)
                  .savePricing(context);
              appBarViewModel.toggleEditMode();
              Navigator.pop(context, 'updated');
            } else {
              appBarViewModel.toggleEditMode();
            }
          },
          deleteDocInfo: ['pricing', pricing.pricingID],
          body: _buildBody(context, appBarViewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppBarViewModel appBarViewModel) {
    final viewModel = Provider.of<PricingDetailsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldRow(
            "رقم التسعير",
            viewModel.pricing.pricingID,
            isEditable: false,
            appBarViewModel: appBarViewModel,
          ),
          const SizedBox(height: 10),
          _buildFieldRow(
            "التاريخ",
            viewModel.pricing.createdDate
                .toLocal()
                .toIso8601String()
                .split('T')[0],
            isEditable: false,
            appBarViewModel: appBarViewModel,
          ),
          const SizedBox(height: 20),
          appBarViewModel.isEditing
              ? _buildUserDropdown(context, viewModel)
              : _buildFieldRow(
                  "اسم المستخدم",
                  viewModel.userOptions
                      .firstWhere((u) => u.id == viewModel.selectedUserID,
                          orElse: () => User(
                              id: '',
                              fullName: 'غير معروف',
                              address: '',
                              phone: '',
                              role: ''))
                      .fullName,
                  isEditable: false,
                  appBarViewModel: appBarViewModel,
                ),
          const SizedBox(height: 10),
          _buildTotalsRow(context, viewModel),
          const SizedBox(height: 10),
          if (appBarViewModel.isEditing)
            _buildAddProductButton(viewModel, context),
          const SizedBox(height: 10),
          Expanded(
              child: _buildProductList(context, viewModel, appBarViewModel)),
          const SizedBox(height: 10),
          _buildNotesField(context, viewModel, appBarViewModel),
        ],
      ),
    );
  }

  Widget _buildAddProductButton(
      PricingDetailsViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.addProductRow,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('إضافة منتج'),
    );
  }

  Widget _buildTotalsRow(
      BuildContext context, PricingDetailsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('${viewModel.totalSalesPrice} ₪',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('إجمالي السعر', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(width: 30),
        Column(
          children: [
            Text('${viewModel.totalDiscount} ₪',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('إجمالي الخصم', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField(BuildContext context,
      PricingDetailsViewModel viewModel, AppBarViewModel appBarViewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: viewModel.notesController,
        enabled: appBarViewModel.isEditing,
        decoration: InputDecoration(
          hintText: 'أضف ملاحظاتك هنا...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        maxLines: 3,
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  Widget _buildFieldRow(String label, String value,
      {required bool isEditable, required AppBarViewModel appBarViewModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        isEditable
            ? Flexible(
                child: TextField(
                  controller: TextEditingController(text: value),
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                ),
              )
            : Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
      ],
    );
  }

  Widget _buildUserDropdown(
      BuildContext context, PricingDetailsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'اسم الشخص: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              value: viewModel.selectedUserID,
              hint: const Text('اختر الشخص'),
              items: viewModel.userOptions.map((user) {
                return DropdownMenuItem(
                  value: user.id,
                  child: Text(user.fullName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  viewModel.setUserID(value);
                }
              },
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(BuildContext context,
      PricingDetailsViewModel viewModel, AppBarViewModel appBarViewModel) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: viewModel.productSelections.length,
      itemBuilder: (context, index) {
        final product = viewModel.productSelections[index];
        return ProductSelectionComponent(
          productOptions: viewModel.productOptions,
          productData: product,
          isEditable: appBarViewModel.isEditing,
          onProductChanged: (updatedProduct) {
            viewModel.updateProductData(index, updatedProduct);
          },
          onRemove: () => viewModel.removeProductRow(index),
        );
      },
    );
  }
}
