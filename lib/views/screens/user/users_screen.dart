import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/user_model.dart';
import 'package:simple_finance/view_models/user/users_view_model.dart';
import 'user_details_screen.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/entity_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}
 
class UsersScreenState extends State<UsersScreen> {
  late List<User> users;
  @override
  void initState() {
    super.initState();

    final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);
    usersViewModel.fetchAllUsers();
    users = usersViewModel.users;
  }

  Future<void> _navigateToUsersDetail(User user) async {
    final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(user: user),
      ),
    );

    if (result == 'updated' || result == 'deleted') {
      await usersViewModel.fetchAllUsers();
      setState(() {
        users = usersViewModel.users;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'الأشخاص',
      bottomSelectedIndex: 1,
      body: Column(
        children: [
          Expanded(
            child: users.isEmpty
                ? const Center(child: Text("لا يوجد أشخاص لعرضهم"))
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return EntityCard(
                        title: user.fullName,
                        additional: "العنوان: ${user.address}",
                        secoundaryTitle: "الرقم: ${user.phone}₪",
                        secoundaryAdditional: "الوطيفة: ${user.role}₪",
                        onTap: () => _navigateToUsersDetail(user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
