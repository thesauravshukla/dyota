import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class SortButton extends StatelessWidget {
  final String selectedSortOption;
  final VoidCallback onShowSortOptions;
  final Logger _logger = Logger('SortButton');

  SortButton({
    Key? key,
    required this.selectedSortOption,
    required this.onShowSortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info(
        'Building SortButton with selectedSortOption: $selectedSortOption');
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: Icon(Icons.sort, color: Colors.black),
        label: Text(selectedSortOption, style: TextStyle(color: Colors.black)),
        onPressed: () {
          _logger.info('SortButton pressed to show sort options');
          onShowSortOptions();
        },
      ),
    );
  }
}
