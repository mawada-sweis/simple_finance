import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:simple_finance/components/delete_confirmation_dialog.dart';
import '../models/user_model.dart';
import '../components/app_bar.dart';
import '../components/menu.dart';
import '../components/buttom_bar.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  UserDetailsScreenState createState() => UserDetailsScreenState();
}

class UserDetailsScreenState extends State<UserDetailsScreen> {
  var logger = Logger();
  bool _isMenuOpen = false;
  bool _isEditing = false;
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _addressController = TextEditingController(text: widget.user.address);
    _phoneController = TextEditingController(text: widget.user.phone);
    _roleController = TextEditingController(text: widget.user.role);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  Future<void> _updateUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .update({
        'full_name': _fullNameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'role': _roleController.text,
      });

      // Close edit mode and refresh
      setState(() {
        _isEditing = false;
      });

      Navigator.pop(context, "updated");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث  معلومات الشخص بنجاح')),
      );
    } catch (e) {
      logger.e("Error updating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم حفظ التغييرات')),
      );
    }
  }

  Future<void> _deleteUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .delete();
      Navigator.pop(context, 'deleted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف الشخص بنجاح')),
      );
    } catch (e) {
      logger.e("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في حذف المنتج')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(onConfirmDelete: _deleteUser);
      },
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing && _hasChanges) {
      _updateUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        title: "معلومات الشخص",
        leadingIcon: Icons.menu,
        onLeadingIconPressed: _toggleMenu,
        showReturnIcon: true,
        onReturnPressed: () {
          Navigator.pop(context);
        },
        showEditIcon: true,
        onEditPressed: _toggleEditMode,
        isEditing: _isEditing,
        showDeleteIcon: true,
        onDeletePressed: _showDeleteConfirmationDialog,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildTextField("الاسم", _fullNameController, _isEditing),
                _buildTextField("العنوان", _addressController, _isEditing),
                _buildTextField("رقم الجوال", _phoneController, _isEditing),
                _buildTextField("الدور", _roleController, _isEditing),
              ],
            ),
          ),
          CustomMenu(
            isOpen: _isMenuOpen,
            onClose: _closeMenu,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(
      String label, TextEditingController controller, bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !isEditable,
          onChanged: (value) {
            setState(() {
              _hasChanges = true; // Track changes
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
