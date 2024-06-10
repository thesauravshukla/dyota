import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final int index; // Unique index for the card
  final String name;
  final String address;
  final bool isSelected;
  final Function(int?) onSelected;
  final VoidCallback onEdit;
  final Function(bool) onMainAddressChanged;
  final VoidCallback onDelete; // Add this line for delete callback

  const AddressCard({
    Key? key,
    required this.index,
    required this.name,
    required this.address,
    required this.isSelected,
    required this.onSelected,
    required this.onEdit,
    required this.onMainAddressChanged,
    required this.onDelete, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns the Edit button with the first line
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // Removes default padding
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Minimizes tap target size
                      ),
                      child:
                          Text('Edit', style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(width: 8), // Space between Edit and Delete buttons
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: onDelete, // Use the onDelete callback here
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
                height:
                    4), // Decreased line spacing between the name and the address
            Text(address,
                style:
                    TextStyle(height: 1.2)), // Adjusted line height for address
            SizedBox(height: 16),
            InkWell(
              onTap: () => onSelected(index),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected
                        ? Colors.black
                        : Colors.grey, // Check box turns black when selected
                  ),
                  SizedBox(width: 8),
                  Text('Use as the shipping address'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
