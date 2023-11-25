import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFieldSection {
  static Widget buildTextFormField(BuildContext context, String label,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: TextFormField(
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
            borderSide: BorderSide(
                color: Colors.black, width: 2.0), // Black border when typing
          ),
          labelStyle:
              TextStyle(color: Colors.black), // Black label when floating
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        obscureText: isPassword,
      ),
    );
  }

  static Widget buildDateFormField(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
            controller.text = formattedDate;
          }
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: controller,
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
                borderSide: BorderSide(
                    color: Colors.black,
                    width: 2.0), // Black border when typing
              ),
              labelStyle:
                  TextStyle(color: Colors.black), // Black label when floating
              filled: true,
              fillColor: Colors.white,
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
