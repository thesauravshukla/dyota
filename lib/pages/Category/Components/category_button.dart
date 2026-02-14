import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CategoryButton extends StatelessWidget {
  final String label; // Text label for the button
  final bool isSelected; // Indicates if the button is selected
  final VoidCallback onTap; // Callback function for tap event
  final Logger _logger = Logger('CategoryButton');

  CategoryButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info(
        'Building CategoryButton with label: $label, isSelected: $isSelected');
    return GestureDetector(
      onTap: () {
        _logger.info(
            'CategoryButton tapped with label: $label - ${isSelected ? "deselecting" : "selecting"}');
        onTap();
      }, // Handle tap event
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // Padding inside the container
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row takes minimum space
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 16,
                  semanticLabel: 'Deselect $label',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
