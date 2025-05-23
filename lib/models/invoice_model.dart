import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  String invoiceID;
  String userID;
  List<String> productsID;
  List<int> productQuantities;
  List<double> productDiscounts;
  DateTime createdDate;
  DateTime? updatedDate;

  Invoice({
    required this.invoiceID,
    required this.userID,
    required this.productsID,
    required this.productQuantities,
    required this.productDiscounts,
    required this.createdDate,
    this.updatedDate,
  });

  // Convert Firestore document to Invoice model
  factory Invoice.fromFirestore(Map<String, dynamic> data, String id) {
    return Invoice(
      invoiceID: id,
      userID: data['userID'] ?? '',
      productsID: List<String>.from(data['productsID'] ?? []),
      productQuantities: List<int>.from(data['productQuantities'] ?? []),
      productDiscounts: (data['productDiscounts'] as List<dynamic>?)
              ?.map((value) => (value is num)
                  ? value.toDouble()
                  : double.tryParse(value.toString()) ?? 0.0)
              .toList() ??
          [],
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      updatedDate: data['updatedDate'] != null
          ? (data['updatedDate'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Invoice model to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'productsID': productsID,
      'productQuantities': productQuantities,
      'productDiscounts': productDiscounts,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }
}
