import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class SearchViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Product> _results = [];
  bool _isLoading = false;

  List<Product> get results => _results;
  bool get isLoading => _isLoading;

  Future<void> executeSearch(BuildContext context, String collectionName,
      String fieldName, String query) async {
    _isLoading = true;
    notifyListeners();

    _results =
        await _databaseService.searchProducts(collectionName, fieldName, query);

    _isLoading = false;
    notifyListeners();
  }

  void resetSearch() {
    _results = [];
    notifyListeners();
  }
}
