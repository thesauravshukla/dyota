import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black),
      ),
      trailing: const Icon(Icons.navigate_next, color: Colors.black),
      onTap: () {
        // Placeholder for tap functionality
      },
    );
  }
}
