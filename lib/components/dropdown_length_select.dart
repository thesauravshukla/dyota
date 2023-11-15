import 'package:flutter/material.dart';

class DropdownLengthSelect extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  DropdownLengthSelect({this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Order Length',
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 1.0), // Black border for default
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black,
                width: 1.0), // Black border for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black,
                width: 2.0), // Black border for focused state
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
