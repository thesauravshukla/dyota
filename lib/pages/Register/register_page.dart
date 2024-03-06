import 'package:dyota/components/my_button.dart';
import 'package:dyota/components/my_textfield.dart';
import 'package:dyota/components/square_tile.dart';
import 'package:dyota/pages/Login/Services/auth_service.dart';
import 'package:dyota/pages/Login/login_page.dart'; // Adjust the path according to your project structure
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var showInvalidCredentials = 0;

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Close the progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registration Successful'),
          duration: const Duration(seconds: 2),
        ),
      );
      // Wait for the SnackBar to be displayed for a few seconds
      await Future.delayed(const Duration(seconds: 2));
      // Navigate directly to the LoginPage class
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                onTap: widget.onTap)), // Assuming LoginPage constructor
      );
    } catch (e) {
      Navigator.pop(context); // Close the progress dialog
      setState(() {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-email':
              showInvalidCredentials = 1;
              break;
            case 'weak-password':
              showInvalidCredentials = 2;
              break;
            case 'email-already-in-use':
              showInvalidCredentials = 3;
              break;
            default:
              showInvalidCredentials = 4;
              break;
          }
        }
      });
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
                  // Logo and heading
                  // Logo
                  const Column(
                    children: [
                      Icon(
                        Icons.texture,
                        size: 100,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      SizedBox(height: 10),

                      // Heading "dyota" with cool font
                      const Text(
                        'dyota',
                        style: TextStyle(
                            fontFamily: 'AlfaSlab',
                            fontSize: 25.0,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  // Password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // Confirm Password Textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 45),
                  // Register button
                  MyButton(
                    onTap: signUserUp,
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    buttonText: "Register Now",
                  ),
                  const SizedBox(height: 20),
                  // Or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Google sign-in button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google sign in
                      SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/images/google.png',
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Not a member? Register now
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Login Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
