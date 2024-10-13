import 'package:flutter/material.dart';
import './customes/custome_app_bar.dart';
import './customes/custome_buttom_bar.dart';
import './customes/custome_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_finance/models/product_model.dart';
import 'components/basic_search.dart';
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

      // For now, just print the results to the console
      for (var product in _searchResults) {
        logger.i("product.name ${product.name}");
        logger.i("product.categoryId ${product.categoryId}");
        logger.i("product.color ${product.color}");
        logger.i("product.purchasePrice ${product.purchasePrice.toString()}");
        logger.i("product.salePrice ${product.salePrice.toString()}");
        logger.i("product.averageCost ${product.averageCost.toString()}");
        logger.i("product.size ${product.size}");
        logger.i("product.stockQuantity ${product.stockQuantity.toString()}");
        logger.i("product.supplierId ${product.supplierId}");
        logger
            .i("product.initialQuantity ${product.initialQuantity.toString()}");
        logger.i("product.note ${product.note}");
      }
    } catch (e) {
      logger.e('Error searching for products: $e');
    }
  }

  void _onFieldChange(String? newField) {
    setState(() {
      _selectedField = newField!;
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
                          showRecentSearches: _showRecentSearches,
                          selectedField: _selectedField,
                          onSearch: _searchProducts,
                          onFieldChange: _onFieldChange,
                          toggleRecentSearches: _toggleRecentSearches,
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
