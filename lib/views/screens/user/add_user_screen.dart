import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/view_models/user/user_details_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/build_text_field.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addUserViewModel = Provider.of<UserDetailsViewModel>(context);

    return MainScaffold(
      title: 'إضافة منتج',
      bottomSelectedIndex: 0,
      showSaveIcon: true,
      onSavePressed: () async {
        await addUserViewModel.addUser(context);
        Navigator.pop(context, 'added');
      },
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SharedTextField(
              label: 'الاسم',
              controller: addUserViewModel.nameController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'العنوان',
              controller: addUserViewModel.addressController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'الرقم',
              controller: addUserViewModel.phoneController,
              readOnly: false,
            ),
            SharedTextField(
              label: 'الوظيفة',
              controller: addUserViewModel.roleController,
              readOnly: false,
            ),
          ],
        ),
      ),
    );
  }
}
