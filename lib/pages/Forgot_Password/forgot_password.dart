import 'package:dyota/components/my_button.dart';
import 'package:dyota/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  final Function()? onTap;
  const ForgotPassword({Key? key, required this.onTap}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  bool showInvalidCredentials =
      false; // Track if invalid credentials should be shown

  void resetPassword() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      Navigator.pop(context); // Dismiss the loading circle
      // Show a message that a password reset email has been sent only if successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'A password reset link has been sent to ${emailController.text}'),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Dismiss the loading circle
      String errorMessage = 'An error occurred. Please try again later.';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'Username not registered';
        }
      }
      // Show appropriate error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Icon(
                    Icons.texture,
                    size: 100,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'dyota',
                    style: TextStyle(
                        fontFamily: 'AlfaSlab',
                        fontSize: 25.0,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  if (showInvalidCredentials)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Invalid credentials or user not found',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10),
                  MyButton(
                    onTap: resetPassword,
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    buttonText: "Reset Password",
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
