import 'package:cloud_firestore/cloud_firestore.dart';

class Pricing {
  String pricingID;
  String userID;
  List<String> productsID;
  List<int> productQuantities;
  double salePrice;
  DateTime createdDate;
  DateTime? updatedDate;

  Pricing({
    required this.pricingID,
    required this.userID,
    required this.productsID,
    required this.productQuantities,
    required this.salePrice,
    required this.createdDate,
    this.updatedDate,
  });

  // Convert Firestore document to Pricing model
  factory Pricing.fromFirestore(Map<String, dynamic> data, String id) {
    return Pricing(
      pricingID: id,
      userID: data['userID'] ?? '',
      productsID: List<String>.from(data['productsID'] ?? []),
      productQuantities: List<int>.from(data['productQuantities'] ?? []),
      salePrice: (data['salePrice'] as num).toDouble(),
      createdDate: (data['createdDate'] as Timestamp).toDate(),
      updatedDate: data['updatedDate'] != null
          ? (data['updatedDate'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Pricing model to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'productsID': productsID,
      'productQuantities': productQuantities,
      'salePrice': salePrice,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }
}
