import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/product_view_model.dart';
import '../../view_models/search_view_model.dart';
import '../shared/main_scaffold.dart';
import '../shared/entity_card.dart';
import '../shared/seach_component.dart';
import '../../models/product_model.dart';

class ProductScreen extends StatefulWidget {
  final List<Product> searchResults;

  const ProductScreen(this.searchResults, {super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.searchResults.isEmpty) {
        productViewModel.fetchAllProducts();
      } else {
        productViewModel.setProducts(widget.searchResults);
      }
    });
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
      body: Column(
        children: [
          SearchComponent(
            onSearch: (field, query) async {
              await searchViewModel.search('products', field, query);
              productViewModel.setProducts(searchViewModel.results);
            },
            onReset: () {
              searchViewModel.resetSearch();
              productViewModel.fetchAllProducts();
            },
            fieldOptions: [
              SearchFieldOption(displayName: 'اسم', firebaseFieldName: 'name'),
              SearchFieldOption(
                  displayName: 'الملاحظات', firebaseFieldName: 'note'),
            ],
          ),
          Expanded(
            child: Consumer<ProductViewModel>(
              builder: (context, viewModel, child) {
                return viewModel.products.isEmpty
                    ? const Center(
                        child: Text("لا توجد نتائج بحث",
                            textDirection: TextDirection.rtl))
                    : ListView.builder(
                        itemCount: viewModel.products.length,
                        itemBuilder: (context, index) {
                          final product = viewModel.products[index];
                          return EntityCard(
                            title: product.name,
                            quantityText: "الكمية: ${product.stockQuantity}",
                            purchaseText: "الشراء: ${product.purchasePrice}₪",
                            saleText: "البيع: ${product.salePrice}₪",
                            onTap: () {
                              // Define an action when the card is tapped
                            },
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
