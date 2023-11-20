import 'package:flutter/material.dart';

Widget buildPasswordField(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
    child: TextFormField(
      obscureText: true, // This ensures the text is hidden
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(fontSize: 16),
    ),
  );
}
