import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/login_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          // if (snapshot.hasData) {
          //   return HomePage();
          // }
          // // user is NOT logged in
          // else {¯¸
          return LoginPage();
          // }
        },
      ),
    );
  }
}
