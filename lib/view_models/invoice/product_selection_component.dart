import 'package:flutter/material.dart';
import 'package:simple_finance/models/product_model.dart';
import 'package:simple_finance/views/shared/dropdown_search_component.dart';

class ProductSelectionComponent extends StatefulWidget {
  final List<Product> productOptions;
  final Function(ProductSelectionData) onProductChanged;
  final VoidCallback onRemove;
  final ProductSelectionData productData;
  final bool isEditable;

  const ProductSelectionComponent({
    super.key,
    required this.productOptions,
    required this.onProductChanged,
    required this.onRemove,
    required this.productData,
    this.isEditable = true,
  });

  @override
  ProductSelectionComponentState createState() =>
      ProductSelectionComponentState();
}

class ProductSelectionComponentState extends State<ProductSelectionComponent> {
  late String? selectedProductID;
  late String productName;
  late double purchasePrice;
  late double salePrice;
  late int quantity;
  late double discount;
  late double total;
  late List<Product> filteredProductOptions;

  @override
  void initState() {
    super.initState();
    selectedProductID = widget.productData.productID;
    productName = widget.productData.productName;
    purchasePrice = widget.productData.purchasePrice;
    salePrice = widget.productData.salePrice;
    quantity = widget.productData.quantity;
    discount = widget.productData.discount;
    total = widget.productData.total;
    filteredProductOptions = List.from(widget.productOptions);
  }

  void _updateTotal() {
    setState(() {
      total = (salePrice - discount) * quantity;
    });
    widget.onProductChanged(ProductSelectionData(
      productID: selectedProductID ?? '',
      productName: productName,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      quantity: quantity,
      discount: discount,
      total: total,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: widget.isEditable
                  ? DropdownSearchComponent<Product>(
                      label: '',
                      hintText: 'اختر المنتج',
                      items: filteredProductOptions,
                      displayValue: (product) => product.name,
                      idValue: (product) => product.id,
                      initialValue: widget.productOptions
                          .firstWhere(
                            (product) => product.id == selectedProductID,
                            orElse: () => Product(
                                id: '',
                                name: 'غير معروف',
                                purchasePrice: 0.0,
                                salePrice: 0.0,
                                averageCost: 0.0,
                                categoryId: 'غير معروف',
                                color: 'غير معروف',
                                initialQuantity: 0,
                                lastPurchasePrice: 0.0,
                                note: '',
                                size: 'غير معروف',
                                stockQuantity: 0,
                                supplierId: 'غير معروف',
                                unit: 'غير معروف'),
                          )
                          .name,
                      onItemSelected: (selectedProductID) {
                        final selectedProduct = widget.productOptions
                            .firstWhere(
                                (product) => product.id == selectedProductID);
                        setState(() {
                          this.selectedProductID = selectedProduct.id;
                          productName = selectedProduct.name;
                          purchasePrice = selectedProduct.purchasePrice;
                          salePrice = selectedProduct.salePrice;
                        });
                        _updateTotal();
                      },
                      onSearch: (query) {
                        setState(() {
                          filteredProductOptions = widget.productOptions
                              .where((product) => product.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                      onReset: () {
                        setState(() {
                          filteredProductOptions =
                              List.from(widget.productOptions);
                        });
                      },
                    )
                  : Text(
                      productName,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
            ),
            if (widget.isEditable)
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: widget.onRemove,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInfoField('الكمية', quantity.toString(), (value) {
                setState(() {
                  quantity = int.tryParse(value) ?? 1;
                });
                _updateTotal();
              }),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildInfoField(
                  'سعر الشراء', purchasePrice.toStringAsFixed(2)),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildInfoField('سعر البيع', salePrice.toStringAsFixed(2)),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildInfoField('الخصم', discount.toString(), (value) {
                setState(() {
                  discount = double.tryParse(value) ?? 0.0;
                });
                _updateTotal();
              }),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildInfoField('الإجمالي', total.toStringAsFixed(2)),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildInfoField(String label, String initialValue,
      [ValueChanged<String>? onChanged]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
        TextField(
          controller: TextEditingController(text: initialValue),
          enabled: onChanged != null && widget.isEditable,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }
}

class ProductSelectionData {
  final String productID;
  final String productName;
  final double purchasePrice;
  final double salePrice;
  final double discount;
  final int quantity;
  final double total;

  ProductSelectionData({
    required this.productID,
    required this.productName,
    required this.purchasePrice,
    required this.salePrice,
    required this.quantity,
    required this.discount,
    required this.total,
  });
}
