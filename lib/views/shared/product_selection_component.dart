import 'package:flutter/material.dart';
import 'package:simple_finance/models/product_model.dart';

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
              child: DropdownButton<String>(
                value:
                    widget.productOptions.any((p) => p.id == selectedProductID)
                        ? selectedProductID
                        : null,
                hint: const Text('اختر المنتج',
                    style: TextStyle(color: Colors.black)),
                items: widget.productOptions.map((product) {
                  return DropdownMenuItem(
                    value: product.id,
                    child: Text(product.name,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
                onChanged: widget.isEditable
                    ? (value) {
                        if (value != null) {
                          final selectedProduct = widget.productOptions
                              .firstWhere((p) => p.id == value);
                          setState(() {
                            selectedProductID = selectedProduct.id;
                            productName = selectedProduct.name;
                            purchasePrice = selectedProduct.purchasePrice;
                            salePrice = selectedProduct.salePrice;
                          });
                          _updateTotal();
                        }
                      }
                    : null,
                isExpanded: true,
                dropdownColor: Colors.white,
              ),
            ),
            if (widget.isEditable)
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: widget.onRemove,
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildInfoField('الكمية', quantity.toString(), (value) {
                quantity = int.tryParse(value) ?? 1;
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
                discount = double.tryParse(value) ?? 0.0;
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
