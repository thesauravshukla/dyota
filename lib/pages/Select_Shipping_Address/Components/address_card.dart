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

  // Parse the formatted address string into components
  Map<String, String> _parseAddress() {
    final parts = address.split(',');
    return {
      'street': parts.isNotEmpty ? parts[0].trim() : '',
      'city': parts.length > 1 ? parts[1].trim() : '',
      'state': parts.length > 2 ? parts[2].trim() : '',
      'postalCode': parts.length > 3 ? parts[3].trim() : '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final addressParts = _parseAddress();

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text('Edit', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    ),
                    SizedBox(width: 8), // Space between Edit and Delete buttons
                    IconButton(
                      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onSurface),
                      tooltip: 'Delete address',
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            // Display formatted address components with proper styling
            Text(
              addressParts['street'] ?? '',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '${addressParts['city'] ?? ''}, ${addressParts['state'] ?? ''}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'PIN: ${addressParts['postalCode'] ?? ''}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
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
