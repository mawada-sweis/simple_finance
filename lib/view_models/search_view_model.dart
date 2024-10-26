import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:simple_finance/models/product_model.dart';

class SearchViewModel extends ChangeNotifier {
  var logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _results = [];
  bool _isLoading = false;

  List<Product> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> search(
      String collectionName, String fieldName, String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where(fieldName, isGreaterThanOrEqualTo: query)
          .where(fieldName, isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      _results = snapshot.docs
          .map((doc) =>
              Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      logger.e("Error searching: $e");
      _results = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void resetSearch() {
    _results = [];
    notifyListeners();
  }
}
