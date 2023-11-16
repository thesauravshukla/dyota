import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/components/profile_app_bar.dart';
import 'package:dyota/components/profile_list_tile.dart';
import 'package:dyota/components/user_account_header.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(),
      body: ListView(
        children: const <Widget>[
          UserAccountHeader(),
          ProfileListTile(
              icon: Icons.shopping_cart,
              title: 'My orders',
              subtitle: 'Already have 12 orders'),
          ProfileListTile(
              icon: Icons.location_on,
              title: 'Shipping addresses',
              subtitle: '3 addresses'),
          ProfileListTile(
              icon: Icons.payment,
              title: 'Payment methods',
              subtitle: 'Visa **34'),
          ProfileListTile(
              icon: Icons.card_giftcard,
              title: 'Promocodes',
              subtitle: 'You have special promocodes'),
          ProfileListTile(
              icon: Icons.rate_review,
              title: 'My reviews',
              subtitle: 'Reviews for 4 items'),
          ProfileListTile(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Notifications, password'),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
