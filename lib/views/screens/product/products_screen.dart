import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/product/product_details_view_model.dart';
import '../../shared/add_button_component.dart';
import 'add_product_screen.dart';
import 'product_details_screen.dart';
import '../../../view_models/product/product_view_model.dart';
import '../../../view_models/search_view_model.dart';
import '../../shared/main_scaffold.dart';
import '../../shared/entity_card.dart';
import '../../shared/search_component.dart';
import '../../../models/product_model.dart';

class ProductScreen extends StatefulWidget {
  final List<Product> searchResults;

  const ProductScreen({super.key, this.searchResults = const []});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  late List<Product> searchResults = [];
  bool _isInitialLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    if (!_isInitialLoad) {
      if (widget.searchResults.isNotEmpty) {
        searchResults = widget.searchResults;
      } else {
        productViewModel.fetchAllProducts().then((_) {
          setState(() {
            searchResults = productViewModel.products;
          });
        });
      }
      _isInitialLoad = true;
    }
  }

  Future<void> _navigateToProductDetail(Product product) async {
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );

    if (result == 'updated' || result == 'deleted' || result == 'added') {
      await productViewModel.fetchAllProducts();
      setState(() {
        searchResults = productViewModel.products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchViewModel =
        Provider.of<SearchViewModel>(context, listen: false);
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);
    return MainScaffold(
      title: 'المنتجات',
      bottomSelectedIndex: 1,
      body: Stack(
        children: [
          Column(
            children: [
              SearchComponent(
                onSearch: (field, query) async {
                  await searchViewModel.executeSearch(
                      context, 'products', field, query);
                  setState(() {
                    searchResults = searchViewModel.results;
                  });
                },
                onReset: () {
                  productViewModel.fetchAllProducts();
                  setState(() {
                    searchResults = productViewModel.products;
                  });
                },
                fieldOptions: [
                  SearchFieldOption(
                      displayName: 'اسم', firebaseFieldName: 'name'),
                  SearchFieldOption(
                      displayName: 'الملاحظات', firebaseFieldName: 'note'),
                ],
              ),
              Expanded(
                child: searchResults.isEmpty
                    ? const Center(
                        child: Text("لا توجد نتائج بحث",
                            textDirection: TextDirection.rtl))
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return EntityCard(
                            title: product.name,
                            additional: "الكمية: ${product.stockQuantity}",
                            secoundaryTitle:
                                "الشراء: ${product.purchasePrice}₪",
                            secoundaryAdditional:
                                "البيع: ${product.salePrice}₪",
                            onTap: () => _navigateToProductDetail(product),
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
                      create: (_) => ProductDetailViewModel(),
                      child: const AddProductScreen(),
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
