import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../components/app_bar.dart';
import '../components/buttom_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        title: 'تفاصيل المنتج',
        leadingIcon: Icons.menu,
        onLeadingIconPressed: () {
          // Handle menu toggle (if needed)
        },
        showReturnIcon: true,
        onReturnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Directionality(
            textDirection: TextDirection.rtl, // Set right-to-left direction
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailBox('الاسم', product.name),
                _buildDetailBox('الصنف', product.categoryId),
                _buildDetailBox('اللون', product.color.isNotEmpty ? product.color : 'لا يوجد لون'),
                _buildDetailBox('سعر الشراء', product.purchasePrice.toStringAsFixed(2)),
                _buildDetailBox('سعر البيع', product.salePrice.toStringAsFixed(2)),
                _buildDetailBox('متوسط التكلفة', product.averageCost.toStringAsFixed(2)),
                _buildDetailBox('الحجم', product.size.isNotEmpty ? product.size : 'لا يوجد حجم'),
                _buildDetailBox('الكمية الحالية', product.stockQuantity.toString()),
                _buildDetailBox('معرف المورد', product.supplierId.isNotEmpty ? product.supplierId : 'لا يوجد معرف'),
                _buildDetailBox('الكمية الأولية', product.initialQuantity.toString()),
                _buildDetailBox('الملاحظات', product.note.isNotEmpty ? product.note : 'لا توجد ملاحظات'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  // Helper method to build a read-only detail box
  Widget _buildDetailBox(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align labels to the start (right in RTL)
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
