import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final String selectedSortOption;
  final VoidCallback onShowSortOptions;

  const SortButton({
    Key? key,
    required this.selectedSortOption,
    required this.onShowSortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: Icon(Icons.sort, color: Colors.black),
        label: Text(selectedSortOption, style: TextStyle(color: Colors.black)),
        onPressed: onShowSortOptions,
      ),
    );
  }
}
