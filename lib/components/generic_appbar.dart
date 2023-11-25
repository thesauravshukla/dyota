import 'package:flutter/material.dart';

class genericAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // Constructor to accept title input
  genericAppbar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black, // AppBar background color
      iconTheme: IconThemeData(color: Colors.white), // Icon color
      title: Text(title, style: TextStyle(color: Colors.white)), // Text color
      leading: IconButton(
        icon: Icon(Icons.arrow_back), // Back button icon
        onPressed: () =>
            Navigator.of(context).pop(), // Action to pop the current screen
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
