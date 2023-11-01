import 'package:dyota/components/my_button.dart';
import 'package:dyota/components/my_textfield.dart';
import 'package:dyota/components/square_tile.dart';
import 'package:dyota/services/auth_service.dart';
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
  final confirmPasswordController =
      TextEditingController(); // Add a separate controller for confirm password
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
      // Registration successful, navigate to the next screen or perform any other necessary actions
    } catch (e) {
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

    Navigator.pop(context);
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
                  const SizedBox(height: 10),
                  // Logo and heading
                  const Column(
                    children: [
                      Icon(
                        Icons.texture,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'dyota',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'CoolFont',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Welcome back message
                  const Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

                  const SizedBox(height: 20),

                  // Invalid credentials message
                  if (showInvalidCredentials == 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Invalid Email ID',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (showInvalidCredentials == 2)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Weak Password',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (showInvalidCredentials == 3)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Email already exists',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (showInvalidCredentials == 4)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Registration failed',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 45),
                  // Register button
                  MyButton(
                    onTap: signUserUp,
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    buttonText: "Register Now",
                  ),
                  const SizedBox(height: 50),
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
                  // Google + Apple sign-in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google sign in
                      SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/images/google.png',
                      ),
                      SizedBox(width: 20),
                      // Apple sign in
                      SquareTile(
                        onTap: () {},
                        imagePath: 'lib/images/apple.png',
                      ),
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
