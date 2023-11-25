import 'package:flutter/material.dart';

class UserAccountHeader extends StatelessWidget {
  const UserAccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      accountName: Text(
        "Matilda Brown",
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        "matildabrown@mail.com",
        style: TextStyle(color: Colors.white),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/profile_picture.png'),
      ),
    );
  }
}
