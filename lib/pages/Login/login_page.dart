import 'package:dyota/components/my_button.dart';
import 'package:dyota/components/my_textfield.dart';
import 'package:dyota/components/square_tile.dart';
import 'package:dyota/pages/Forgot_Password/forgot_password.dart';
import 'package:dyota/pages/Login/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showInvalidCredentials =
      false; // Track if invalid credentials should be shown

// Sign user in method
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.black), // Change color to black
          ),
        );
      },
    );

    // Try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      setState(() {
        showInvalidCredentials = true; // Show invalid credentials message
      });
    }

    // Pop the loading circle
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
                  const SizedBox(height: 30),

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

                  const SizedBox(height: 20),

                  // Welcome back, you've been missed
                  const Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16),
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

                  // Invalid credentials message
                  if (showInvalidCredentials)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Invalid credentials',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Forgot password?
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgotPassword(onTap: () {
                                        // Define what happens when you tap on the ForgotPassword screen's onTap
                                        // For example, navigate back to the login page
                                      })),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Sign-in button
                  MyButton(
                    onTap: signUserIn,
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    buttonText: "Sign In",
                  ),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 10),

                  // Not a member? Register now
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Register Now',
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
