import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Color buttonColor;
  final Color textColor;

  const MyButton({
    Key? key,
    required this.onTap,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: buttonColor, // Use the buttonColor input argument
          borderRadius: BorderRadius.circular(15), // Set the border radius to 8
          border: Border.all(
            color: Colors.white, // Set the border color to white
            width: 2, // Set the border width
          ),
        ),
        child: Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: textColor, // Use the textColor input argument
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
