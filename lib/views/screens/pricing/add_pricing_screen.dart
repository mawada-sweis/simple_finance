import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/pricing/add_pricing_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/product_selection_component.dart';

class AddPricingScreen extends StatefulWidget {
  const AddPricingScreen({super.key});

  @override
  AddPricingScreenState createState() => AddPricingScreenState();
}

class AddPricingScreenState extends State<AddPricingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<AddPricingViewModel>(context, listen: false);
      viewModel.resetFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddPricingViewModel>(context);

    return MainScaffold(
      title: 'إضافة تسعير جديد',
      showSaveIcon: true,
      bottomSelectedIndex: -1,
      onSavePressed: () async {
        try {
          await viewModel.savePricing(context);
          Navigator.pop(context, 'added');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      },
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "رقم التسعير: ${viewModel.pricingID}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "التاريخ: ${viewModel.createdDate.toLocal().toIso8601String().split('T')[0]}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildUserDropdown(viewModel),
                  const SizedBox(height: 20),
                  _buildOverviewTotals(viewModel, context),
                  const SizedBox(height: 10),
                  _buildAddProductButton(viewModel, context),
                  const SizedBox(height: 10),
                  Expanded(child: _buildProductList(viewModel)),
                  const SizedBox(height: 10),
                  _buildNoteField(viewModel),
                ],
              ),
            ),
    );
  }

  Widget _buildUserDropdown(AddPricingViewModel viewModel) {
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
        )),
      ],
    );
  }

  Widget _buildOverviewTotals(
      AddPricingViewModel viewModel, BuildContext context) {
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

  Widget _buildAddProductButton(
      AddPricingViewModel viewModel, BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.addProductEntry,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('إضافة منتج'),
    );
  }

  Widget _buildProductList(AddPricingViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.productSelections.length,
      itemBuilder: (context, index) {
        final product = viewModel.productSelections[index];

        return ProductSelectionComponent(
          productData: product,
          isEditable: true,
          productOptions: viewModel.productOptions,
          onProductChanged: (productData) {
            viewModel.updateProductData(index, productData);
          },
          onRemove: () {
            viewModel.removeProductRow(index);
          },
        );
      },
    );
  }

  Widget _buildNoteField(AddPricingViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: viewModel.notesController,
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
}
