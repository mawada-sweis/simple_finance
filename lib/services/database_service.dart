import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_finance/models/invoice_model.dart';
import 'package:simple_finance/models/pricing_model.dart';
import 'package:simple_finance/models/transaction_model.dart';
import 'package:simple_finance/models/user_model.dart';
import '../models/product_model.dart';
import 'package:logger/logger.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();

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
      'last_purchase_price': product.lastPurchasePrice,
      'unit': product.unit,
    });
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update({
      'full_name': user.fullName,
      'address': user.address,
      'phone': user.phone,
      'role': user.role,
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
      QuerySnapshot snapshot =
          await _firestore.collection(collectionName).get();

      List<Product> allProducts = snapshot.docs.map((doc) {
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
          lastPurchasePrice:
              (data['last_purchase_price'] as num?)?.toDouble() ?? 0.0,
          unit: data['unit'] ?? '',
        );
      }).toList();

      return allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add({
      'name': product.name,
      'category_id': product.categoryId,
      'color': product.color,
      'purchase_price': product.purchasePrice,
      'sale_price': product.salePrice,
      'size': product.size,
      'stock_quantity': product.stockQuantity,
      'supplier_id': product.supplierId,
      'initial_quantity': product.initialQuantity,
      'note': product.note,
      'last_purchase_price': product.lastPurchasePrice,
      'unit': product.unit,
      'average_cost': product.averageCost,
    });
  }

  Future<void> addUser(User user) async {
    await _firestore.collection('users').add({
      'full_name': user.fullName,
      'address': user.address,
      'phone': user.phone,
      'role': user.role,
    });
  }

  Future<T?> getDocByID<T>(
    String collectionName,
    String docID,
    T Function(Map<String, dynamic> data, String id) fromFirestore,
  ) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection(collectionName).doc(docID).get();
      if (docSnapshot.exists) {
        return fromFirestore(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching document: $e');
      return null;
    }
  }

  Future<String?> getLastDocID(String collectionName) async {
    final query = await _firestore.collection(collectionName).get();
    if (query.docs.isEmpty) return null;
    final docID = query.docs.map((doc) => int.tryParse(doc.id) ?? 0).toList();
    final lastID = docID.isNotEmpty ? docID.reduce((a, b) => a > b ? a : b) : 0;
    final nextID = lastID + 1;
    return nextID.toString();
  }

  Future<void> addPricing(Pricing pricing) async {
    await _firestore
        .collection('pricing')
        .doc(pricing.pricingID)
        .set(pricing.toFirestore());
  }

  Future<void> updatePricing(Pricing pricing) async {
    await _firestore
        .collection('pricing')
        .doc(pricing.pricingID)
        .update(pricing.toFirestore());
  }

  Future<void> addInvoice(Invoice invoice) async {
    await _firestore
        .collection('invoice')
        .doc(invoice.invoiceID)
        .set(invoice.toFirestore());
  }

  Future<void> updateInvoice(Invoice invoice) async {
    await _firestore
        .collection('invoice')
        .doc(invoice.invoiceID)
        .update(invoice.toFirestore());
  }

    // Fetch all transactions
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('transactions').get();
      return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      throw Exception("Error fetching transactions: $e");
    }
  }

  // Create a new transaction
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      await _firestore.collection('transactions').add(transaction.toMap());
    } catch (e) {
      throw Exception("Error creating transaction: $e");
    }
  }

  // Delete a transaction by trans ID
  Future<void> deleteTransaction(String transID) async {
    try {
      await _firestore.collection('transactions').doc(transID).delete();
    } catch (e) {
      throw Exception("Error deleting transaction: $e");
    }
  }

  // Delete all transactions of a specific invoice
  //NEED UPDATE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Future<void> deleteTransactionsByInvoiceID(String invoiceID) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('invoiceID', isEqualTo: invoiceID)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception("Error deleting invoice transactions: $e");
    }
  }

  // Update a transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _firestore.collection('transactions').doc(transaction.transID).update(transaction.toMap());
    } catch (e) {
      throw Exception("Error updating transaction: $e");
    }
  }
}