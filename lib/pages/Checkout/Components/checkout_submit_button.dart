import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          // TODO: Implement submit order logic
        },
        child: Center(child: Text('SUBMIT ORDER')),
      ),
    );
  }
}
