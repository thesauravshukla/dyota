import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/My_Bag/my_bag.dart';
import 'package:dyota/pages/My_Orders/my_orders.dart';
import 'package:dyota/pages/Profile/Components/profile_list_tile.dart';
import 'package:dyota/pages/Profile/Components/user_account_header.dart';
import 'package:dyota/pages/Select_Shipping_Address/select_shipping_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/generic_appbar.dart';
import '../../pages/Authentication/auth_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _addressCount = 0;
  int _pendingOrdersCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAddressCount();
    _fetchPendingOrdersCount();
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyBag()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  Future<void> _fetchAddressCount() async {
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    if (email.isNotEmpty) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();
        setState(() {
          _addressCount = userDoc['addressCount'] ?? 0;
        });
      } catch (e) {
        print('Error fetching address count: $e');
      }
    }
  }

  Future<void> _fetchPendingOrdersCount() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      try {
        QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('orders')
            .where('status', isEqualTo: 'Pending')
            .get();

        setState(() {
          _pendingOrdersCount = orderSnapshot.size;
        });
      } catch (e) {
        print('Error fetching pending orders count: $e');
      }
    }
  }

  void _handleLogout(BuildContext context) async {
    // Show confirmation dialog before logging out
    final bool confirmLogout = await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Log Out'),
              content: const Text('Are you sure you want to log out?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed

    // Only proceed with logout if confirmed
    if (confirmLogout) {
      await FirebaseAuth.instance.signOut();
      // Navigate to auth page after logout, removing all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Profile', showBackButton: false),
      body: ListView(
        children: <Widget>[
          const UserAccountHeader(),
          _buildProfileListTile(
            icon: Icons.shopping_cart,
            title: 'My orders',
            subtitle: '$_pendingOrdersCount pending orders',
            onTap: () => _navigateTo(context, MyOrdersPage()),
          ),
          _buildProfileListTile(
            icon: Icons.location_on,
            title: 'Shipping addresses',
            subtitle: '$_addressCount addresses',
            onTap: () => _navigateTo(context, ShippingAddressesScreen()),
          ),
          // Logout button
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 2, // Set the current index as needed
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }

  Widget _buildProfileListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ProfileListTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
