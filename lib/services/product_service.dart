import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProduct(Product product) async {
    await _firestore.collection('products').doc(product.id).update({
      'name': product.name,
      'category_id': product.categoryId,
      'color': product.color,
      'purchase_price': product.purchasePrice,
      'sale_price': product.salePrice,
      'average_cost': product.averageCost,
      'size': product.size,
      'stock_quantity': product.stockQuantity,
      'supplier_id': product.supplierId,
      'initial_quantity': product.initialQuantity,
      'note': product.note,
    });
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
