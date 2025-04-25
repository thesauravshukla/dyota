import 'package:flutter/material.dart';

class AddressDialog extends StatefulWidget {
  final String title;
  final String? initialTitle;
  final String? initialAddress;
  final Function(String, String) onSave;

  const AddressDialog({
    Key? key,
    required this.title,
    this.initialTitle,
    this.initialAddress,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddressDialogState createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  late TextEditingController titleController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);

    // Split the initial address into components if available
    if (widget.initialAddress != null) {
      final addressParts = _parseAddress(widget.initialAddress!);
      streetController = TextEditingController(text: addressParts['street']);
      cityController = TextEditingController(text: addressParts['city']);
      stateController = TextEditingController(text: addressParts['state']);
      postalCodeController =
          TextEditingController(text: addressParts['postalCode']);
    } else {
      streetController = TextEditingController();
      cityController = TextEditingController();
      stateController = TextEditingController();
      postalCodeController = TextEditingController();
    }
  }

  Map<String, String> _parseAddress(String fullAddress) {
    // Simple parsing logic - can be enhanced based on your address format
    final parts = fullAddress.split(',');
    return {
      'street': parts.isNotEmpty ? parts[0].trim() : '',
      'city': parts.length > 1 ? parts[1].trim() : '',
      'state': parts.length > 2 ? parts[2].trim() : '',
      'postalCode': parts.length > 3 ? parts[3].trim() : '',
    };
  }

  String _formatAddress() {
    return '${streetController.text}, ${cityController.text}, ${stateController.text}, ${postalCodeController.text}';
  }

  @override
  void dispose() {
    titleController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title/Name',
                  hintText: 'e.g. Home, Office',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              Text(
                'Address Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  hintText: 'e.g. 123 Main St, Apt 4B',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  hintText: 'e.g. Mumbai',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  hintText: 'e.g. Maharashtra',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: postalCodeController,
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  hintText: 'e.g. 400001',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter postal code';
                  }
                  if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                    return 'Enter a valid 6-digit postal code';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final formattedAddress = _formatAddress();
              widget.onSave(titleController.text, formattedAddress);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
