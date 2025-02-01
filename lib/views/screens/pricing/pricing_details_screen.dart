import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/user_model.dart';
import 'package:simple_finance/view_models/app_bar_view_model.dart';
import 'package:simple_finance/views/shared/dropdown_search_component.dart';
import '../../../models/pricing_model.dart';
import '../../../view_models/pricing/pricing_details_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../../view_models/pricing/product_selection_component.dart';

enum PricingMode { add, edit }

class PricingDetailsScreen extends StatelessWidget {
  final Pricing pricing;
  final PricingMode mode;

  const PricingDetailsScreen({
    super.key,
    required this.pricing,
    this.mode = PricingMode.edit,
  });

  @override
  Widget build(BuildContext context) {
    final appBarViewModel =
        Provider.of<AppBarViewModel>(context, listen: false);

    // Reset edit mode when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mode == PricingMode.edit) appBarViewModel.resetEditMode();
    });

    return Consumer<AppBarViewModel>(
      builder: (context, appBarViewModel, child) {
        return MainScaffold(
          title:
              mode == PricingMode.add ? 'إضافة تسعير جديد' : 'تفاصيل التسعير',
          showEditIcon: mode == PricingMode.edit,
          showDeleteIcon: mode == PricingMode.edit,
          showSaveIcon: mode == PricingMode.add,
          bottomSelectedIndex: -1,
          onSavePressed: () async {
            if (mode == PricingMode.edit && appBarViewModel.isEditing) {
              await Provider.of<PricingDetailsViewModel>(context, listen: false)
                  .updatePricing(context);
              appBarViewModel.toggleEditMode();
              Navigator.pop(context, 'updated');
            } else {
              await Provider.of<PricingDetailsViewModel>(context, listen: false)
                  .savePricing(context);
              Navigator.pop(
                  context, mode == PricingMode.add ? 'added' : 'updated');
            }
          },
          deleteDocInfo:
              mode == PricingMode.edit ? ['pricing', pricing.pricingID] : null,
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
            mode == PricingMode.edit
                ? viewModel.pricing.pricingID
                : viewModel.pricingID,
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
          appBarViewModel.isEditing || mode == PricingMode.add
              ? DropdownSearchComponent<User>(
                  label: 'اسم الشخص',
                  hintText: 'اختر الشخص',
                  items: viewModel.filteredUserOptions,
                  displayValue: (user) => user.fullName,
                  idValue: (user) => user.id,
                  initialValue: viewModel.selectedUserID != null
                      ? viewModel.getUserNameByID(viewModel.selectedUserID)
                      : null,
                  onItemSelected: (selectedUserID) {
                    viewModel.setUserID(selectedUserID);
                  },
                  onSearch: (query) {
                    viewModel.filterUsers(query);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      (context as Element).markNeedsBuild();
                    });
                  },
                  onReset: () {
                    viewModel.resetUserOptions();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      (context as Element).markNeedsBuild();
                    });
                  },
                )
              : _buildFieldRow(
                  "اسم الشخص",
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
          _buildTotalsRow(context, viewModel, appBarViewModel),
          const SizedBox(height: 25),
          _buildFieldRow(
            "أسماء المنتجات",
            '',
            isEditable: false,
            appBarViewModel: appBarViewModel,
          ),
          if (mode == PricingMode.add || appBarViewModel.isEditing)
            _buildAddProductButton(viewModel, context),
          const SizedBox(height: 10),
          Expanded(
              child: _buildProductList(context, viewModel, appBarViewModel)),
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

  Widget _buildTotalsRow(BuildContext context,
      PricingDetailsViewModel viewModel, AppBarViewModel appBarViewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('${viewModel.totalPurchasePrice} ₪',
                    style: Theme.of(context).textTheme.headlineSmall),
            Text('إجمالي السعر', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            appBarViewModel.isEditing || mode == PricingMode.add
                ? SizedBox(
                    width: 100,
                    child: TextField(
                      controller: TextEditingController(
                          text: viewModel.salePrice.toString()),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                      ),

                      onSubmitted: (value) {
                        viewModel.updateSalePrice(
                            double.tryParse(value) ?? viewModel.salePrice);
                      },
                    ),
                  )
                : Text('${viewModel.salePrice} ₪',
                    style: Theme.of(context).textTheme.headlineSmall),
            Text('سعر البيع', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            Text('${viewModel.total} ₪',
                style: Theme.of(context).textTheme.headlineSmall),
            Text('إجمالي', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
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
          isEditable: mode == PricingMode.add || appBarViewModel.isEditing,
          onProductChanged: (updatedProduct) {
            viewModel.updateProductData(index, updatedProduct);
          },
          onRemove: () => viewModel.removeProductRow(index),
        );
      },
    );
  }
}
