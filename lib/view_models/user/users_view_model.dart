import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class UsersViewModel extends ChangeNotifier {
  List<User> _users = [];
  List<User> get users => _users;

  void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    _users = await DatabaseService().fetchAllFromCollection<User>(
      'users',
      fromFirestore: (data, id) => User(
        id: id,
        address: data['address'] ?? '',
        fullName: data['full_name'] ?? '',
        phone: data['phone'] ?? '',
        role: data['role'] ?? '',
      ),
    );
    notifyListeners();
  }
}
