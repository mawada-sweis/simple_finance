import 'package:flutter/material.dart';

class SearchFieldOption {
  final String displayName;
  final String firebaseFieldName;

  SearchFieldOption(
      {required this.displayName, required this.firebaseFieldName});
}

class SearchComponent extends StatelessWidget {
  final Function(String, String) onSearch;
  final VoidCallback onReset;
  final List<SearchFieldOption> fieldOptions;
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _selectedField;

  SearchComponent({
    super.key,
    required this.onSearch,
    required this.onReset,
    required this.fieldOptions,
  }) : _selectedField =
            ValueNotifier<String>(fieldOptions.first.firebaseFieldName);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث هنا...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).colorScheme.secondaryContainer),
                  border: InputBorder.none,
                ),
                textDirection: TextDirection.rtl,
                onSubmitted: (value) {
                  if (_selectedField.value.isNotEmpty && value.isNotEmpty) {
                    onSearch(_selectedField.value, value);
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
              ),
              onPressed: () {
                _searchController.clear();
                onReset();
              },
              color: Theme.of(context).colorScheme.error,
            ),
            ValueListenableBuilder<String>(
              valueListenable: _selectedField,
              builder: (context, value, child) {
                return DropdownButton<String>(
                  value: value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      _selectedField.value = newValue;
                    }
                  },
                  items: fieldOptions
                      .map((fieldOption) => DropdownMenuItem(
                            value: fieldOption.firebaseFieldName,
                            child: Text(fieldOption.displayName,
                                textDirection: TextDirection.rtl),
                          ))
                      .toList(),
                  underline: Container(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
