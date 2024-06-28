import 'package:flutter/material.dart';

class AddressDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: initialTitle);
    TextEditingController addressController =
        TextEditingController(text: initialAddress);

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ],
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
            onSave(titleController.text, addressController.text);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
