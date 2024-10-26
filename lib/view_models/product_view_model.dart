import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/fetch_utils.dart';

class ProductViewModel extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  Future<void> fetchAllProducts() async {
    _products = await fetchAllFromCollection<Product>(
      'products',
      fromFirestore: (data, id) => Product.fromFirestore(data, id),
    );
    notifyListeners();
  }
}
