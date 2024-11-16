import 'package:cloud_firestore/cloud_firestore.dart';

class Pricing {
  String pricingID;
  String userID;
  List<String> productsID;
  List<int> productQuantities;
  List<double> productDiscounts;
  DateTime createdDate;
  DateTime? updatedDate;
  String? notes;

  Pricing(
      {required this.pricingID,
      required this.userID,
      required this.productsID,
      required this.productQuantities,
      required this.productDiscounts,
      required this.createdDate,
      this.updatedDate,
      this.notes});

  // Convert Firestore document to Pricing model
  factory Pricing.fromFirestore(Map<String, dynamic> data, String id) {
    return Pricing(
      pricingID: id,
      userID: data['userID'] ?? '',
      productsID: List<String>.from(data['productsID'] ?? []),
      productQuantities: List<int>.from(data['productQuantities'] ?? []),
      productDiscounts: (data['productDiscounts'] as List<dynamic>?)
              ?.map((value) => (value is num)
                  ? value.toDouble()
                  : double.tryParse(value.toString()) ?? 0.0)
              .toList() ??
          [],
      createdDate:(data['createdDate'] as Timestamp).toDate(),
      updatedDate: data['updatedDate'] != null
          ? (data['updatedDate'] as Timestamp).toDate()
          : null,
      notes: data['notes'] ?? '',
    );
  }

  // Convert Pricing model to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'productsID': productsID,
      'productQuantities': productQuantities,
      'productDiscounts': productDiscounts,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'notes': notes,
    };
  }
}
