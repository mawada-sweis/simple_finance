import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../view_models/user/user_details_view_model.dart';
import '../../../view_models/app_bar_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/build_text_field.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final appBarViewModel = Provider.of<AppBarViewModel>(context, listen: true);

    return ChangeNotifierProvider(
      create: (_) => UserDetailsViewModel(user: user),
      child: Consumer<UserDetailsViewModel>(
        builder: (context, viewModel, child) {
          return MainScaffold(
            title: 'معلومات الشخص',
            showEditIcon: true,
            showDeleteIcon: true,
            bottomSelectedIndex: 0,
            onSavePressed: () async {
              await viewModel.saveChanges(context);
              appBarViewModel.toggleEditMode();
              Navigator.pop(context, 'updated');
            },
            deleteDocInfo: ['users', user.id],
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SharedTextField(
                    label: 'الاسم',
                    controller: viewModel.nameController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'العنوان',
                    controller: viewModel.addressController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'الرثم',
                    controller: viewModel.phoneController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                  SharedTextField(
                    label: 'الوظيفة',
                    controller: viewModel.roleController,
                    readOnly: !appBarViewModel.isEditing,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
