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
        _logger.info('CategoryButton tapped with label: $label');
        onTap();
      }, // Handle tap event
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 12, vertical: 8), // Padding inside the container
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(
                  255, 0, 0, 0) // Background color when selected
              : const Color.fromARGB(
                  255, 255, 255, 255), // Background color when not selected
          borderRadius: BorderRadius.circular(20), // Rounded corners
          border: Border.all(color: Colors.black), // Border color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row takes minimum space
          children: [
            Text(
              label, // Display the label text
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Text color based on selection
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(
                    left: 4.0), // Padding between text and icon
                child: Icon(
                  Icons.close, // Close icon
                  color: Colors.white, // Icon color
                  size: 16, // Icon size
                ),
              ),
          ],
        ),
      ),
    );
  }
}
