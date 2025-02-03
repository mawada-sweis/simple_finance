import 'package:flutter/material.dart';
import 'package:simple_finance/models/transaction_model.dart';
import 'package:simple_finance/services/database_service.dart';
import 'package:logger/logger.dart';

class TransactionViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  Logger logger = Logger();

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Fetch transactions from Firestore
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = await _databaseService.fetchTransactions();
    } catch (e) {
      logger.e("Error loading transactions: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _databaseService.createTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      logger.e("Error adding transaction: $e");
    }
  }

  // Delete a transaction
  Future<void> removeTransaction(String transID) async {
    try {
      await _databaseService.deleteTransaction(transID);
      _transactions.removeWhere((t) => t.transID == transID);
      notifyListeners();
    } catch (e) {
      logger.e("Error deleting transaction: $e");
    }
  }

  // Update a transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _databaseService.updateTransaction(transaction);
      int index =
          _transactions.indexWhere((t) => t.transID == transaction.transID);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      logger.e("Error updating transaction: $e");
    }
  }
}
