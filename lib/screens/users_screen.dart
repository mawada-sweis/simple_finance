import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:simple_finance/components/app_bar.dart';
import 'package:simple_finance/components/menu.dart';
import 'package:simple_finance/screens/user_details.dart';
import '../models/user_model.dart';
import '../components/user_card.dart';
import '../components/buttom_bar.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  UsersScreenState createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  var logger = Logger();
  List<User> _users = [];
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<User> users = snapshot.docs.map((doc) {
        return User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        _users = users;
      });
    } catch (e) {
      logger.e("Error fetching users: $e");
    }
  }

  // Handle when a user card is tapped
  void onUserTap(User user) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: user),
      ),
    );

    if (result == 'updated' || result == 'deleted') {
      await fetchUsers();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        title: 'قائمة الأشخاص',
        showReturnIcon: true,
        leadingIcon: Icons.menu,
        onLeadingIconPressed: _toggleMenu,
        onReturnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      return UserCard(
                        user: _users[index],
                        onTap: onUserTap,
                      );
                    },
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
}
