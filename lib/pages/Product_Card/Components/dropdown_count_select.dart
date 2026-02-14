import 'package:flutter/material.dart';

class DropdownCountSelect extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const DropdownCountSelect(
      {super.key, this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Count Value',
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: 2.0),
          ),
        ),
        value: selectedValue,
        isExpanded: true,
        items: ['length1', 'length2', 'Medium'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
