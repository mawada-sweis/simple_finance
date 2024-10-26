import 'package:cloud_firestore/cloud_firestore.dart';

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
