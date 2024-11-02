import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<T>> fetchAllFromCollection<T>(
    String collectionName, {
    required T Function(Map<String, dynamic> data, String id) fromFirestore,
  }) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    return querySnapshot.docs
        .map((doc) => fromFirestore(doc.data(), doc.id))
        .toList();
  }

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

  Future<void> deleteDoc(String collectionName, String docID) async {
    try {
      await _firestore.collection(collectionName).doc(docID).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  Future<List<Product>> searchProducts(
      String collectionName, String fieldName, String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where(fieldName, isGreaterThanOrEqualTo: query)
          .where(fieldName, isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          categoryId: data['category_id'] ?? '',
          color: data['color'] ?? '',
          purchasePrice: (data['purchase_price'] as num?)?.toDouble() ?? 0.0,
          salePrice: (data['sale_price'] as num?)?.toDouble() ?? 0.0,
          averageCost: (data['average_cost'] as num?)?.toDouble() ?? 0.0,
          size: data['size'] ?? '',
          stockQuantity: data['stock_quantity'] as int? ?? 0,
          supplierId: data['supplier_id'] ?? '',
          initialQuantity: data['initial_quantity'] as int? ?? 0,
          note: data['note'] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
