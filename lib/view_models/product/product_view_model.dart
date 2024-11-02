import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  Future<void> fetchAllProducts() async {
    _products = await DatabaseService().fetchAllFromCollection<Product>(
      'products',
      fromFirestore: (data, id) => Product(
        id: id,
        name: data['name'] ?? '',
        categoryId: data['category_id'] ?? '',
        color: data['color'] ?? '',
        purchasePrice: (data['purchase_price'] ?? 0).toDouble(),
        salePrice: (data['sale_price'] ?? 0).toDouble(),
        averageCost: (data['average_cost'] ?? 0).toDouble(),
        size: data['size'] ?? '',
        stockQuantity: (data['stock_quantity'] ?? 0).toInt(),
        supplierId: data['supplier_id'] ?? '',
        initialQuantity: (data['initial_quantity'] ?? 0).toInt(),
        note: data['note'] ?? '',
        lastPurchasePrice: (data['last_purchase_price'] ?? 0).toDouble(),
        unit: data['unit'] ?? '',
      ),
    );
    notifyListeners();
  }
}
