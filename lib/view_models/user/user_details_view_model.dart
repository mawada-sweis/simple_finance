import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final User? user;
  final DatabaseService _databaseService = DatabaseService();
  bool hasChanges = false;

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController roleController;

  UserDetailsViewModel({this.user}) {
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: user?.fullName ?? '');
    addressController = TextEditingController(text: user?.address ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    roleController = TextEditingController(text: user?.role ?? '');
    _addChangeListeners();
  }

  void _addChangeListeners() {
    nameController.addListener(() => hasChanges = true);
    addressController.addListener(() => hasChanges = true);
    phoneController.addListener(() => hasChanges = true);
    roleController.addListener(() => hasChanges = true);
  }

  Future<void> saveChanges(BuildContext context) async {
    if (user != null && hasChanges) {
      try {
        await _databaseService.updateUser(User(
          id: user!.id,
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

  Future<void> addUser(BuildContext context) async {
    try {
      final newUser = User(
        id: '',
        fullName: nameController.text,
        address: addressController.text,
        phone: phoneController.text,
        role: roleController.text,
      );

      await _databaseService.addUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الشخص بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إضافة الشخص')),
      );
    }
  }

  void clearControllers() {
    nameController.clear();
    addressController.clear();
    phoneController.clear();
    roleController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.dispose();
  }
}
