import 'package:flutter/material.dart';
import '../components/app_bar.dart';
import '../components/buttom_bar.dart';
import '../components/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_finance/models/product_model.dart';
import '../components/basic_search.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var logger = Logger();
  bool _isMenuOpen = false;
  String _selectedField = 'name';
  bool _showRecentSearches = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  List<Product> _searchResults = [];

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

  void _toggleRecentSearches() {
    setState(() {
      _showRecentSearches = !_showRecentSearches;
    });
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) return;

    // Add the search query to recent searches if it's new
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.sublist(0, 5);
        }
      });
    }

    try {
      // Query Firestore based on the selected field
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(_selectedField, isGreaterThanOrEqualTo: query)
          .where(_selectedField, isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        _searchResults = products;
      });

      // Navigate to ProductScreen and pass the search results
      Navigator.pushNamed(
        // ignore: use_build_context_synchronously
        context,
        '/products',
        arguments: {'searchResults': _searchResults},
      );
    } catch (e) {
      logger.e('Error searching for products: $e');
    }
  }

  void _onFieldChange(String? newField) {
    setState(() {
      _selectedField = newField!;
    });
  }

  void _resetSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppBar(
        title: "الصفحة الرئيسية",
        leadingIcon: Icons.menu,
        onLeadingIconPressed: _toggleMenu,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ابحث عن المنتج الذي تريده',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        const SizedBox(height: 30),
                        BasicSearch(
                          searchController: _searchController,
                          recentSearches: _recentSearches,
                          showRecentSearches: true,
                          selectedField: _selectedField,
                          onSearch: _searchProducts,
                          onFieldChange: _onFieldChange,
                          toggleRecentSearches: _toggleRecentSearches,
                          onClearSearch: _resetSearch,
                        ),
                      ],
                    ),
                  ),
                ),
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
}
