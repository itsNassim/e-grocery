import 'package:flutter/material.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';

class CustomSearchBar extends StatelessWidget {
  final double width;
  CustomSearchBar({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return StandardSearchAnchor(
      searchBar: StandardSearchBar(
        height: 50,
        width: width * 0.8,
        bgColor: Colors.white,
      ),
      suggestions: StandardSuggestions(
        suggestions: [
          StandardSuggestion(text: 'Suggestion 1',),
          StandardSuggestion(text: 'Suggestion 2'),
          StandardSuggestion(text: 'Suggestion 3'),
        ],
      ),
    );
  }
}
