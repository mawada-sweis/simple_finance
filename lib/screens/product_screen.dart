import 'package:flutter/material.dart';
import 'package:simple_finance/components/menu.dart';
import '../models/product_model.dart';
import '../components/product_card.dart';
import '../components/app_bar.dart';
import '../components/buttom_bar.dart';
import '../components/basic_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class ProductScreen extends StatefulWidget {
  final List<Product> searchResults;

  const ProductScreen({super.key, required this.searchResults});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  var logger = Logger();

  bool _isMenuOpen = false;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _showRecentSearches = false;

  String _searchQuery = '';
  String _selectedField = 'name';

  List<Product> _products = [];
  DocumentSnapshot? _lastDocument;

  final int _limit = 20;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    // Add a listener to detect when the user reaches the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore &&
          _searchQuery.isEmpty) {
        _loadProducts();
      }
    });
    // Check if search results are passed from HomeScreen
    if (widget.searchResults.isNotEmpty) {
      _products = widget.searchResults;
    } else {
      _loadProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Function to load all products in chunks
  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot;

      if (_lastDocument == null) {
        snapshot = await FirebaseFirestore.instance
            .collection('products')
            .orderBy('name')
            .limit(_limit)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('products')
            .orderBy('name')
            .startAfterDocument(_lastDocument!)
            .limit(_limit)
            .get();
      }

      if (snapshot.docs.length < _limit) {
        _hasMore = false;
        _isLoading = false;
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        List<Product> products = snapshot.docs.map((doc) {
          return Product.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        setState(() {
          _products.addAll(products);
        });
      }
    } catch (e) {
      logger.e('Error loading products: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Search products by name
  Future<void> _searchProducts(String query) async {
    setState(() {
      _isLoading = true;
      _products = [];
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error searching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Reset search and load all products in chunks
  void _resetSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _products = [];
      _lastDocument = null;
      _hasMore = true;
    });
    _loadProducts();
  }

  // Handle recent search toggle
  void _toggleRecentSearches() {
    setState(() {
      _showRecentSearches = !_showRecentSearches;
    });
  }

  // Handle search field change
  void _onFieldChange(String? newField) {
    setState(() {
      _selectedField = newField!;
    });
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
        title: 'المنتجات',
        leadingIcon: Icons.menu,
        onLeadingIconPressed: _toggleMenu,
        showReturnIcon: true,
        onReturnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BasicSearch(
                  searchController: _searchController,
                  onSearch: (query) {
                    if (query.isNotEmpty) {
                      setState(() {
                        _searchQuery = query;
                      });
                      _searchProducts(query);
                    }
                  },
                  recentSearches: _recentSearches,
                  showRecentSearches: _showRecentSearches,
                  selectedField: _selectedField,
                  onFieldChange: _onFieldChange,
                  toggleRecentSearches: _toggleRecentSearches,
                  onClearSearch: _resetSearch,
                ),
              ),
              Expanded(
                child: _isLoading && _products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            itemCount: _products.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _products.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final product = _products[index];
                              return ProductCard(
                                product: product,
                                onTap: (selectedProduct) {
                                  // Navigate to the ProductDetailScreen or handle card tap
                                },
                              );
                            },
                          )
                        : const Center(child: Text('لا توجد منتجات')),
              ),
            ],
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
