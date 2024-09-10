import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAccountHeader extends StatelessWidget {
  const UserAccountHeader({Key? key}) : super(key: key);

  Future<String?> getUserName(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('profileData')
        .where('emailID', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String fullName =
          querySnapshot.docs.first.data()['fullName'] as String? ?? '';
      if (fullName.trim().isEmpty) {
        // If fullName is empty, use the part of the email before the '@'
        return email.split('@').first;
      } else {
        // If fullName is not empty, return it
        return fullName;
      }
    }
    return null; // Return null if the document does not exist
  }

  @override
  Widget build(BuildContext context) {
    User? user =
        FirebaseAuth.instance.currentUser; // Get the current logged-in user
    String userEmail = user?.email ??
        'No email'; // Use the email if available, otherwise show a default message

    return FutureBuilder<String?>(
      future: getUserName(userEmail), // Fetch the user name from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            accountName: null, // Removed the name section
            accountEmail: Text(
              "Loading...",
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle the error state
          return const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            accountName: null, // Removed the name section
            accountEmail: Text(
              "Error",
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          );
        } else {
          // Use the retrieved name or a default value if the snapshot has data
          return UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            accountName: null, // Removed the name section
            accountEmail: Text(
              userEmail,
              style: const TextStyle(color: Colors.white),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
