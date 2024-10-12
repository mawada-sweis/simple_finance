import 'package:flutter/material.dart';
import './customes/custome_app_bar.dart';
import './customes/custome_buttom_bar.dart';
import './customes/custome_menu.dart';
import 'customes/custom_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_finance/models/product_model.dart';
import 'package:simple_finance/components/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;
  List<Product> _products = [];
  bool _isLoading = false;
  Product? _selectedProduct;

  // Toggle the menu state
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  // Close the menu
  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }

  // Fetch products from Firebase
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

      // Convert Firebase documents into Product models
      List<Product> products = snapshot.docs.map((doc) {
        return Product.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print(products);
      // Update state with the fetched products
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Advanced search based on selected field
  Future<void> _advancedSearch(String field, String query) async {
    setState(() {
      _isLoading = true;
      _products = [];
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(field, isGreaterThanOrEqualTo: query)
          .where(field, isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Product> products = snapshot.docs
          .map((doc) =>
              Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle showing detailed product info
  void _showProductDetails(Product product) {
    setState(() {
      _selectedProduct = product;
    });
  }

  // Close detailed product info
  void _closeProductDetails() {
    setState(() {
      _selectedProduct = null;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: CustomeAppBar(
  //       title: "الصفحة الرئيسية",
  //       leadingIcon: Icons.menu,
  //       onLeadingIconPressed: _toggleMenu,
  //     ),
  //     body: Stack(
  //       children: [
  //         const Center(
  //           child: Text("الصفحة الرئيسية"),
  //         ),
  //         CustomMenu(
  //           isOpen: _isMenuOpen,
  //           onClose: _closeMenu,
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: CustomBottomBar(),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: CustomeAppBar(
  //       title: "الصفحة الرئيسية",
  //       leadingIcon: Icons.menu,
  //       onLeadingIconPressed: _toggleMenu,
  //     ),
  //     body: Stack(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               CustomSearchBar(
  //                 onSearch: _performSearch,
  //               ),
  //               const SizedBox(height: 20),
  //               Expanded(
  //                 child: _filteredProducts.isNotEmpty
  //                     ? ListView.builder(
  //                         itemCount: _filteredProducts.length,
  //                         itemBuilder: (context, index) {
  //                           return Card(
  //                             margin: const EdgeInsets.symmetric(vertical: 8),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: Text(
  //                                 _filteredProducts[index],
  //                                 style: const TextStyle(fontSize: 16)
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       )
  //                     : const Center(
  //                         child: Text('ابحث عن منتج موجود'),
  //                       ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // CustomMenu overlay
  //         CustomMenu(
  //           isOpen: _isMenuOpen,
  //           onClose: _closeMenu, // Close the menu when user taps outside
  //         ),
  //       ],
  //     ),
  //     bottomNavigationBar: CustomBottomBar(),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: CustomeAppBar(
  //       title: "الصفحة الرئيسية",
  //       leadingIcon: Icons.menu,
  //       onLeadingIconPressed: _toggleMenu,
  //     ),
  //     body: Stack(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             children: [
  //               // Search bar
  //               TextField(
  //                 onSubmitted: _searchProducts,
  //                 decoration: InputDecoration(
  //                   hintText: 'ابحث عن طريق الاسم',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(25),
  //                   ),
  //                   suffixIcon: const Icon(Icons.search),
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               // Loading indicator
  //               if (_isLoading) const CircularProgressIndicator(),
  //               // Product list
  //               if (_products.isNotEmpty && !_isLoading)
  //                 Expanded(
  //                   child: ListView.builder(
  //                     itemCount: _products.length,
  //                     itemBuilder: (context, index) {
  //                       return ProductCard(
  //                         product: _products[index],
  //                         onTap: _showProductDetails,
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               // No products found message
  //               if (_products.isEmpty && !_isLoading)
  //                 const Center(child: Text('لا يوجد منتج بهذا الاسم')),
  //             ],
  //           ),
  //         ),
  //         // CustomMenu overlay
  //         CustomMenu(
  //           isOpen: _isMenuOpen,
  //           onClose: _closeMenu,
  //         ),
  //         // Expanded product details
  //         if (_selectedProduct != null)
  //           GestureDetector(
  //             onTap: _closeProductDetails,
  //             child: Container(
  //               color: Colors.black.withOpacity(0.5),
  //               child: Center(
  //                 child: Card(
  //                   margin: const EdgeInsets.all(20),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               _selectedProduct!.name,
  //                               style: const TextStyle(
  //                                   fontSize: 20, fontWeight: FontWeight.bold),
  //                             ),
  //                             IconButton(
  //                               icon: Icon(
  //                                 Icons.close,
  //                                 color: Theme.of(context).colorScheme.error,
  //                               ),
  //                               onPressed: _closeProductDetails,
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 16),
  //                         Text(
  //                             'الصنف: ${_selectedProduct!.categoryId.isNotEmpty ? _selectedProduct!.categoryId : 'لا يوجد تصنيف'}'),
  //                         Text(
  //                             'اللون: ${_selectedProduct!.color.isNotEmpty ? _selectedProduct!.color : 'لا يوجد لون'}'),
  //                         Text(
  //                             'سعر الشراء: ${_selectedProduct!.purchasePrice > 0 ? '${_selectedProduct!.purchasePrice.toStringAsFixed(1)} ₪' : 'غير متوفر'}'),
  //                         Text(
  //                             'سعر البيع: ${_selectedProduct!.salePrice > 0 ? _selectedProduct!.salePrice.toStringAsFixed(1) + ' ₪' : 'غير متوفر'}'),
  //                         Text(
  //                             'الكمية الحالية: ${_selectedProduct!.stockQuantity > 0 ? _selectedProduct!.stockQuantity.toString() : 'غير متوفر'}'),
  //                         Text(
  //                             'معرف المورد: ${_selectedProduct!.supplierId.isNotEmpty ? _selectedProduct!.supplierId : 'لا يوجد معرف'}'),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //     bottomNavigationBar: CustomBottomBar(),
  //   );
  // }

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
                // Custom Search Bar with Advanced Search
                CustomSearchBar(
                  onSearch: _searchProducts,
                  onAdvancedSearch: _advancedSearch, // Handle advanced search
                ),
                const SizedBox(height: 20),
                // Loading indicator
                if (_isLoading) const CircularProgressIndicator(),
                // Product list
                if (_products.isNotEmpty && !_isLoading)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: _products[index],
                          onTap: _showProductDetails,
                        );
                      },
                    ),
                  ),
                // No products found message
                if (_products.isEmpty && !_isLoading)
                  const Center(child: Text('ابحث عن منتج موجود')),
              ],
            ),
          ),
          // CustomMenu overlay
          CustomMenu(
            isOpen: _isMenuOpen,
            onClose: _closeMenu,
          ),
          // Expanded product details
          if (_selectedProduct != null)
            GestureDetector(
              onTap: _closeProductDetails,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedProduct!.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: _closeProductDetails,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                              'الصنف: ${_selectedProduct!.categoryId.isNotEmpty ? _selectedProduct!.categoryId : 'لا يوجد تصنيف'}'),
                          Text(
                              'اللون: ${_selectedProduct!.color.isNotEmpty ? _selectedProduct!.color : 'لا يوجد لون'}'),
                          Text(
                              'سعر الشراء: ${_selectedProduct!.purchasePrice > 0 ? _selectedProduct!.purchasePrice : -1}'),
                          Text(
                              'سعر البيع: ${_selectedProduct!.salePrice > 0 ? _selectedProduct!.salePrice : -1}'),
                          Text(
                              'الكمية الحالية: ${_selectedProduct!.stockQuantity > 0 ? _selectedProduct!.stockQuantity : -1}'),
                          Text(
                              'معرف المورد: ${_selectedProduct!.supplierId.isNotEmpty ? _selectedProduct!.supplierId : 'لا يوجد مورد'}'),
                          Text(
                              'الكمية الأولية : ${_selectedProduct!.initialQuantity > 0 ? _selectedProduct!.initialQuantity : -1}'),
                          Text(
                              'ملاحظات: ${_selectedProduct!.note.isNotEmpty ? _selectedProduct!.note : 'لا يوجد ملاحظة'}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
