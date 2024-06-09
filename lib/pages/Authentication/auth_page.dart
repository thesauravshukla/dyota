import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Login_Or_Register/login_or_register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is logged in
            User? user = snapshot.data;
            checkAndCreateUserRecord(user);
            return ParentWidget(); // Your logged-in user's home widget
          } else {
            // User is NOT logged in
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }

  void checkAndCreateUserRecord(User? user) async {
    if (user != null) {
      final usersRef = FirebaseFirestore.instance.collection('users');
      final docRef = usersRef.doc(user.email);

      DocumentSnapshot docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        // Create a new document for the user if it doesn't exist
        await docRef.set(
            {'addressList': [], 'pastOrderList': [], 'currentOrderList': []});

        // Create an empty cartItems sub-collection
        final cartItemsRef = docRef.collection('cartItems');
        await cartItemsRef.add({
          // Add an initial empty document or skip this if you want the collection to be empty initially
        });
      }
    }
  }
}
