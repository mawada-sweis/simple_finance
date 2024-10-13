import 'package:flutter/material.dart';

Widget buildSearchUI({
  required TextEditingController searchController,
  required Function(String) onSearch,
  required Function(String?) onFieldChange,
  required bool showRecentSearches,
  required List<String> recentSearches,
  required String selectedField,
  required VoidCallback toggleRecentSearches,
  required BuildContext context,
}) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
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
            IconButton(
              icon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () => onSearch(searchController.text),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                onTap: toggleRecentSearches,
                decoration: const InputDecoration(
                  hintText: 'مثال: بسكليت',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                onSubmitted: (value) {
                  onSearch(value);
                  toggleRecentSearches();
                },
              ),
            ),
            DropdownButton<String>(
              value: selectedField,
              items: const [
                DropdownMenuItem(value: "name", child: Text("الاسم")),
                DropdownMenuItem(value: "note", child: Text("الملاحظات")),
              ],
              onChanged: onFieldChange,
              underline: Container(),
              dropdownColor: Colors.white,
              icon: const Padding(
                padding: EdgeInsets.only(left: 9.0),
                child: Icon(Icons.arrow_drop_down),
              ),
            ),
          ],
        ),
      ),
      if (showRecentSearches && recentSearches.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: recentSearches.map((search) {
              return ListTile(
                leading: const Icon(Icons.search, color: Colors.grey, size: 20),
                title: Text(search),
                onTap: () {
                  searchController.text = search;
                  onSearch(search);
                  toggleRecentSearches();
                },
              );
            }).toList(),
          ),
        ),
    ],
  );
}
