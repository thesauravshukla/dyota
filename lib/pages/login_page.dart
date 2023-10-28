import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/components/my_button.dart';
import 'package:firstapp/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          // Use ListView instead of SingleChildScrollView
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  // Logo
                  Column(
                    children: [
                      const Icon(
                        Icons.texture,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      // Heading "dyota" with cool font
                      Text(
                        'dyota',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily:
                              'CoolFont', // Replace 'CoolFont' with the desired cool font
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Welcome back, you've been missed
                  Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  // email textfield
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
                  // Forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  // Sign-in button
                  MyButton(
                    onTap: signUserIn,
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                  ),

                  const SizedBox(height: 40),
                  // Or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
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
                        const SizedBox(height: 50),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Google + Apple sign-in buttons
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //google sign in
                      SquareTile(imagePath: 'lib/images/google.png'),

                      SizedBox(width: 20),
                      //apple sign in
                      SquareTile(imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  const SizedBox(height: 50),
                  // Not a member? Register now
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member?',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 4),
                        Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
