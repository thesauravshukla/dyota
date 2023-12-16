import 'package:flutter/material.dart';

class ChoiceChipFilter extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(String) onSelectionChanged;

  const ChoiceChipFilter({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 16.0, 8.0),
        child: Wrap(
          spacing: 8.0,
          children: options.map((option) {
            bool isSelected = selectedOptions.contains(option);
            return ChoiceChip(
              label: Text(option,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black)),
              selected: isSelected,
              selectedColor: Colors.black,
              backgroundColor: Colors.white,
              onSelected: (selected) => onSelectionChanged(option),
            );
          }).toList(),
        ),
      ),
    );
  }
}
