import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/search_view_model.dart';
import '../shared/seach_component.dart';
import '../shared/main_scaffold.dart';
import 'products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return MainScaffold(
      title: 'الصفحة الرئيسية',
      showReturnIcon: false,
      bottomSelectedIndex: 0,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ابحث عن المنتج الذي تريده',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              const SizedBox(height: 30),
              SearchComponent(
                onSearch: (field, query) {
                  searchViewModel.search('products', field, query).then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductScreen(searchViewModel.results),
                      ),
                    );
                  });
                },
                onReset: () {
                  searchViewModel.resetSearch();
                },
                fieldOptions: [
                  SearchFieldOption(
                      displayName: 'اسم', firebaseFieldName: 'name'),
                  SearchFieldOption(
                      displayName: 'الملاحظات', firebaseFieldName: 'note'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
