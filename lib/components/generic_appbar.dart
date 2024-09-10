import 'package:flutter/material.dart';

class genericAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton; // New argument to control back button visibility

  // Constructor to accept title and showBackButton input
  genericAppbar({Key? key, required this.title, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black, // AppBar background color
      iconTheme: const IconThemeData(color: Colors.white), // Icon color
      title: Text(title,
          style: const TextStyle(color: Colors.white)), // Text color
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back), // Back button icon
              onPressed: () => Navigator.of(context)
                  .pop(), // Action to pop the current screen
            )
          : null, // No leading widget if showBackButton is false
      actions: [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
