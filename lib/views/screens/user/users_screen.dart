import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_finance/models/user_model.dart';
import 'package:simple_finance/view_models/user/user_details_view_model.dart';
import 'package:simple_finance/view_models/user/users_view_model.dart';
import 'user_details_screen.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/entity_card.dart';
import '../../shared/add_button_component.dart';
import 'add_user_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  late List<User> users = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);

    if (usersViewModel.users.isEmpty) {
      usersViewModel.fetchAllUsers().then((_) {
        setState(() {
          users = usersViewModel.users;
        });
      });
    } else {
      users = usersViewModel.users;
    }
  }

  Future<void> _navigateToUsersDetail(User user) async {
    final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(user: user),
      ),
    );

    if (result == 'updated' || result == 'deleted' || result == 'added') {
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
      bottomSelectedIndex: -1,
      body: Stack(
        children: [
          Column(
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
                            secoundaryTitle: "الرقم: ${user.phone}",
                            secoundaryAdditional: "الوظيفة: ${user.role}",
                            onTap: () => _navigateToUsersDetail(user),
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: AddButtonComponent(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => UserDetailsViewModel(),
                      child: const AddUserScreen(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
