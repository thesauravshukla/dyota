import 'package:dyota/pages/My%20Orders/my_orders.dart';
import 'package:dyota/pages/Profile/Components/profile_list_tile.dart';
import 'package:dyota/pages/Profile/Components/user_account_header.dart';
import 'package:dyota/pages/Select_Shipping_Address/select_shipping_address.dart';
import 'package:dyota/pages/Settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/generic_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Assuming you have a named route for your login screen, replace '/login' with your actual login route
    // Navigator.pushReplacementNamed(context, '/login');
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
            subtitle: '3 addresses',
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
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ProfileListTile(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'Notifications, password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
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
