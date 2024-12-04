import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/invoice_model.dart';
import 'package:simple_finance/models/user_model.dart';
import 'package:simple_finance/view_models/app_bar_view_model.dart';
import 'package:simple_finance/view_models/invoice/invoice_details_view_model.dart';
import 'package:simple_finance/views/shared/dropdown_search_component.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/product_selection_component.dart';

enum InvoiceMode { add, edit }

class InvoiceDetailsScreen extends StatelessWidget {
  final Invoice invoice;
  final InvoiceMode mode;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
    this.mode = InvoiceMode.edit,
  });

  @override
  Widget build(BuildContext context) {
    final appBarViewModel =
        Provider.of<AppBarViewModel>(context, listen: false);

    // Reset edit mode when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mode == InvoiceMode.edit) appBarViewModel.resetEditMode();
    });

    return Consumer<AppBarViewModel>(
      builder: (context, appBarViewModel, child) {
        return MainScaffold(
          title:
              mode == InvoiceMode.add ? 'إضافة تسعير جديد' : 'تفاصيل التسعير',
          showEditIcon: mode == InvoiceMode.edit,
          showDeleteIcon: mode == InvoiceMode.edit,
          showSaveIcon: mode == InvoiceMode.add,
          bottomSelectedIndex: -1,
          onSavePressed: () async {
            if (mode == InvoiceMode.edit && appBarViewModel.isEditing) {
              await Provider.of<InvoiceDetailsViewModel>(context, listen: false)
                  .updateInvoice(context);
              appBarViewModel.toggleEditMode();
              Navigator.pop(context, 'updated');
            } else {
              await Provider.of<InvoiceDetailsViewModel>(context, listen: false)
                  .saveInvoice(context);
              Navigator.pop(
                  context, mode == InvoiceMode.add ? 'added' : 'updated');
            }
          },
          deleteDocInfo:
              mode == InvoiceMode.edit ? ['invoice', invoice.invoiceID] : null,
          body: _buildBody(context, appBarViewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppBarViewModel appBarViewModel) {
    final viewModel = Provider.of<InvoiceDetailsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldRow(
            "رقم الفاتورة",
            mode == InvoiceMode.edit
                ? viewModel.invoice.invoiceID
                : viewModel.invoiceID,
            isEditable: false,
            appBarViewModel: appBarViewModel,
          ),
          const SizedBox(height: 10),
          _buildFieldRow(
            "التاريخ",
            viewModel.invoice.createdDate
                .toLocal()
                .toIso8601String()
                .split('T')[0],
            isEditable: false,
            appBarViewModel: appBarViewModel,
          ),
          const SizedBox(height: 20),
          appBarViewModel.isEditing || mode == InvoiceMode.add
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
          _buildTotalsRow(context, viewModel),
          const SizedBox(height: 25),
          _buildFieldRow(
            "أسماء المنتجات",
            '',
            isEditable: false,
            appBarViewModel: appBarViewModel,
          ),
          if (mode == InvoiceMode.add || appBarViewModel.isEditing)
            _buildAddProductButton(viewModel, context),
          const SizedBox(height: 10),
          Expanded(
              child: _buildProductList(context, viewModel, appBarViewModel)),
        ],
      ),
    );
  }

  Widget _buildAddProductButton(
      InvoiceDetailsViewModel viewModel, BuildContext context) {
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
      BuildContext context, InvoiceDetailsViewModel viewModel) {
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
      InvoiceDetailsViewModel viewModel, AppBarViewModel appBarViewModel) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: viewModel.productSelections.length,
      itemBuilder: (context, index) {
        final product = viewModel.productSelections[index];
        return ProductSelectionComponent(
          productOptions: viewModel.productOptions,
          productData: product,
          isEditable: mode == InvoiceMode.add || appBarViewModel.isEditing,
          onProductChanged: (updatedProduct) {
            viewModel.updateProductData(index, updatedProduct);
          },
          onRemove: () => viewModel.removeProductRow(index),
        );
      },
    );
  }
}
