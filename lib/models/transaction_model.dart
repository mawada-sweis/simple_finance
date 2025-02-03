import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String transID;
  String invoiceID;
  String transType;
  Timestamp date;
  String statementName;
  String debtorID; // From Accounts Collection
  String creditorID; // From Accounts Collection
  String accountsDebitID; // From Users Collection
  String accountsCreditorID; // From Users Collection
  int quantity;
  double amount;
  double total;

  TransactionModel({
    required this.transID,
    required this.invoiceID,
    required this.transType,
    required this.date,
    required this.statementName,
    required this.debtorID,
    required this.creditorID,
    required this.accountsDebitID,
    required this.accountsCreditorID,
    required this.quantity,
    required this.amount,
  }) : total = quantity * amount;

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'invoice_ID': FirebaseFirestore.instance.doc(invoiceID),
      'trans_type': transType,
      'date': date,
      'statement_name': statementName,
      'debtor_ID': FirebaseFirestore.instance.doc(debtorID),
      'creditor_ID': FirebaseFirestore.instance.doc(creditorID),
      'accounts_debit_ID': FirebaseFirestore.instance.doc(accountsDebitID),
      'accounts_creditor_ID': FirebaseFirestore.instance.doc(accountsCreditorID),
      'quantity': quantity,
      'amount': amount,
      'total': total,
    };
  }

  // Create a TransactionModel from Firestore document
  factory TransactionModel.fromMap(Map<String, dynamic> data, String id) {
    return TransactionModel(
      transID: id,
      invoiceID:(data['invoice_ID'] as DocumentReference).path,
      transType: data['trans_type'] ?? '',
      date: data['date'] ?? Timestamp.now(),
      statementName: data['statement_name'] ?? '',
      debtorID: (data['debtor_ID'] as DocumentReference).path, 
      creditorID: (data['creditor_ID'] as DocumentReference).path, 
      accountsDebitID: (data['accounts_debit'] as DocumentReference).path, 
      accountsCreditorID: (data['accounts_creditor'] as DocumentReference).path, 
      quantity: data['quantity'] ?? 0,
      amount: (data['amount'] ?? 0.0).toDouble(),
    );
  }
}
