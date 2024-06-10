import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/My%20Orders/my_orders.dart';
import 'package:dyota/pages/Profile/Components/profile_list_tile.dart';
import 'package:dyota/pages/Profile/Components/user_account_header.dart';
import 'package:dyota/pages/Select_Shipping_Address/select_shipping_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/generic_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _addressCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAddressCount();
  }

  Future<void> _fetchAddressCount() async {
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    if (email.isNotEmpty) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      setState(() {
        _addressCount = userDoc['addressCount'] ?? 0;
      });
    }
  }

  void _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Profile'),
      body: ListView(
        children: <Widget>[
          const UserAccountHeader(),
          ProfileListTile(
            icon: Icons.shopping_cart,
            title: 'My orders',
            subtitle: 'Already have 12 orders',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOrdersPage()),
              );
            },
          ),
          ProfileListTile(
            icon: Icons.location_on,
            title: 'Shipping addresses',
            subtitle: '$_addressCount addresses',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShippingAddressesScreen()),
              );
            },
          ),
          ProfileListTile(
            icon: Icons.payment,
            title: 'Payment methods',
            subtitle: 'Visa **34',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShippingAddressesScreen()),
              );
            },
          ),
          // Logout button
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _handleLogout(context),
          ),
          // Add more pages if you have them
        ],
      ),
    );
  }
}
