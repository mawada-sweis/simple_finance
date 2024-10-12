import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch; // Callback to handle search input
  final Function(String, String) onAdvancedSearch; // Advanced search callback

  CustomSearchBar({required this.onSearch, required this.onAdvancedSearch});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isAdvancedSearch = false; // For toggling advanced search fields
  String _searchField = 'name'; // Default search field

  void _toggleAdvancedSearch() {
    setState(() {
      _isAdvancedSearch = !_isAdvancedSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Search text field
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Use basic or advanced search based on the state
                        if (_isAdvancedSearch) {
                          widget.onAdvancedSearch(
                              _searchField, _searchController.text);
                        } else {
                          widget.onSearch(_searchController.text);
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (value) {
                          // Use basic or advanced search based on the state
                          if (_isAdvancedSearch) {
                            widget.onAdvancedSearch(_searchField, value);
                          } else {
                            widget.onSearch(value);
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: 'ابحث عن طريق الاسم',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Advanced search button (tune icon)
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: _toggleAdvancedSearch,
            ),
          ],
        ),
        if (_isAdvancedSearch)
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              color: Colors
                  .white, // Set the background color of the field to white
              child: DropdownButtonFormField<String>(
                value: _searchField,
                onChanged: (value) {
                  setState(() {
                    _searchField = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "name", child: Text("الاسم")),
                  DropdownMenuItem(value: "note", child: Text("الملاحظات")),
                ],
                decoration: const InputDecoration(
                  labelText: "اختر حقل البحث",
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors
                    .white, // Set the dropdown list background color to white
              ),
            ),
          ),
      ],
    );
  }
}
