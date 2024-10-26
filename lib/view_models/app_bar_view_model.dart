import 'package:flutter/material.dart';

class AppBarViewModel extends ChangeNotifier {
  bool isEditing = false;

  void toggleEditMode() {
    isEditing = !isEditing;
    notifyListeners();
  }
}
