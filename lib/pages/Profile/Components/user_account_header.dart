import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAccountHeader extends StatelessWidget {
  const UserAccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the current logged-in user
    String userEmail = user?.email ??
        'No email'; // Use the email if available, otherwise show a default message
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      accountName: const Text(
        "Matilda Brown",
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        userEmail,
        style: const TextStyle(color: Colors.white),
      ),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage('assets/profile_picture.png'),
      ),
    );
  }
}
