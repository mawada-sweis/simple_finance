import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final User user;
  final DatabaseService _databaseService = DatabaseService();
  bool hasChanges = false;

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController roleController;

  UserDetailsViewModel(this.user) {
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: user.fullName);
    nameController.addListener(() {
      hasChanges = true;
    });
    addressController = TextEditingController(text: user.address);
    addressController.addListener(() {
      hasChanges = true;
    });
    phoneController = TextEditingController(text: user.phone);
    phoneController.addListener(() {
      hasChanges = true;
    });
    roleController = TextEditingController(text: user.role);
    roleController.addListener(() {
      hasChanges = true;
    });
  }

  Future<void> saveChanges(BuildContext context) async {
    if (hasChanges) {
      try {
        await _databaseService.updateUser(User(
          id: user.id,
          fullName: nameController.text,
          address: addressController.text,
          phone: phoneController.text,
          role: roleController.text,
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
        );
        hasChanges = false;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في حفظ التغييرات')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد تغييرات لحفظها')),
      );
    }
  }

  void disposeControllers() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    roleController.dispose();
  }
}
