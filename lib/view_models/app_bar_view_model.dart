import 'package:flutter/material.dart';
import 'package:simple_finance/services/database_service.dart';
import '../app_routes.dart';

class AppBarViewModel extends ChangeNotifier {
  bool isEditing = false;

  void toggleEditMode() {
    isEditing = !isEditing;
    notifyListeners();
  }

  void handleReturn(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void handleEditSave(VoidCallback? onSavePressed) {
    if (isEditing && onSavePressed != null) {
      onSavePressed();
    } else {
      toggleEditMode();
    }
  }

  Future<void> deleteDocument(List<String>? deleteDocInfo) async {
    if (deleteDocInfo != null && deleteDocInfo.length == 2) {
      try {
        await DatabaseService().deleteDoc(deleteDocInfo[0], deleteDocInfo[1]);
      } catch (e) {
        debugPrint('Error deleting document: $e');
      }
    }
  }
}
