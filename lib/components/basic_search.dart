import 'package:flutter/material.dart';
import '../customes/custome_search_ui.dart';

class BasicSearch extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;
  final List<String> recentSearches;
  final bool showRecentSearches;
  final String selectedField;
  final Function(String?) onFieldChange;
  final VoidCallback toggleRecentSearches;
  final VoidCallback onClearSearch;

  const BasicSearch({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.recentSearches,
    required this.showRecentSearches,
    required this.selectedField,
    required this.onFieldChange,
    required this.toggleRecentSearches,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return buildSearchUI(
      searchController: searchController,
      onSearch: onSearch,
      onFieldChange: onFieldChange,
      showRecentSearches: showRecentSearches,
      recentSearches: recentSearches,
      selectedField: selectedField,
      toggleRecentSearches: toggleRecentSearches,
      onClearSearch: onClearSearch,
      context: context,
    );
  }
}
