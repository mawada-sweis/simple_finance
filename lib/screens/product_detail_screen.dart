import 'package:flutter/material.dart';
import 'package:simple_finance/components/menu.dart';
import '../models/product_model.dart';
import '../components/app_bar.dart';
import '../components/buttom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});
  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  var logger = Logger();

  bool _isMenuOpen = false;
  bool _isEditing = false;
  bool _hasChanges = false;
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _colorController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _averageCostController;
  late TextEditingController _sizeController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _supplierIdController;
  late TextEditingController _initialQuantityController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product.name);
    _categoryController =
        TextEditingController(text: widget.product.categoryId);
    _colorController = TextEditingController(text: widget.product.color);
    _purchasePriceController =
        TextEditingController(text: widget.product.purchasePrice.toString());
    _salePriceController =
        TextEditingController(text: widget.product.salePrice.toString());
    _averageCostController =
        TextEditingController(text: widget.product.averageCost.toString());
    _sizeController = TextEditingController(text: widget.product.size);
    _stockQuantityController =
        TextEditingController(text: widget.product.stockQuantity.toString());
    _supplierIdController =
        TextEditingController(text: widget.product.supplierId);
    _initialQuantityController =
        TextEditingController(text: widget.product.initialQuantity.toString());
    _noteController = TextEditingController(text: widget.product.note);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _colorController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _averageCostController.dispose();
    _sizeController.dispose();
    _stockQuantityController.dispose();
    _supplierIdController.dispose();
    _initialQuantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing && _hasChanges) {
      _saveChanges();
    }
  }

  void _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({
        'name': _nameController.text,
        'category_id': _categoryController.text,
        'color': _colorController.text,
        'purchase_price': double.parse(_purchasePriceController.text),
        'sale_price': double.parse(_salePriceController.text),
        'average_cost': double.parse(_averageCostController.text),
        'size': _sizeController.text,
        'stock_quantity': int.parse(_stockQuantityController.text),
        'supplier_id': _supplierIdController.text,
        'initial_quantity': int.parse(_initialQuantityController.text),
        'note': _noteController.text,
      });

      // Update the local product model
      Product updatedProduct = Product(
        id: widget.product.id,
        name: _nameController.text,
        categoryId: _categoryController.text,
        color: _colorController.text,
        purchasePrice: double.parse(_purchasePriceController.text),
        salePrice: double.parse(_salePriceController.text),
        averageCost: double.parse(_averageCostController.text),
        size: _sizeController.text,
        stockQuantity: int.parse(_stockQuantityController.text),
        supplierId: _supplierIdController.text,
        initialQuantity: int.parse(_initialQuantityController.text),
        note: _noteController.text,
      );

      // Return the updated product to the previous screen
      Navigator.pop(context, updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث  معلومات المنتج بنجاح')),
      );
    } catch (e) {
      logger.e('Error updating product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم حفظ التغييرات')),
      );
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        title: 'تفاصيل المنتج',
        leadingIcon: Icons.menu,
        onLeadingIconPressed: _toggleMenu,
        showReturnIcon: true,
        onReturnPressed: () {
          Navigator.pop(context);
        },
        onEditPressed: _toggleEditMode,
        isEditing: _isEditing,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildTextField('الاسم', _nameController, _isEditing),
                _buildTextField('الصنف', _categoryController, _isEditing),
                _buildTextField('اللون', _colorController, _isEditing),
                _buildTextField(
                    'سعر الشراء', _purchasePriceController, _isEditing),
                _buildTextField('سعر البيع', _salePriceController, _isEditing),
                _buildTextField(
                    'متوسط التكلفة', _averageCostController, _isEditing),
                _buildTextField('الحجم', _sizeController, _isEditing),
                _buildTextField(
                    'الكمية في المخزون', _stockQuantityController, _isEditing),
                _buildTextField(
                    'معرف المورد', _supplierIdController, _isEditing),
                _buildTextField(
                    'الكمية الأولية', _initialQuantityController, _isEditing),
                _buildTextField('ملاحظة', _noteController, _isEditing),
              ],
            ),
          ),
          CustomMenu(isOpen: _isMenuOpen, onClose: _closeMenu)
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(
      String label, TextEditingController controller, bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !isEditable,
          onChanged: (value) {
            setState(() {
              _hasChanges = true; // Track changes
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
