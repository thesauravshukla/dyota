import 'package:flutter/material.dart';

Widget SwitchListTileSection(BuildContext context, String title, bool value) {
  return SwitchListTile(
    title: Text(title),
    value: value,
    onChanged: (bool newValue) {
      // Handle switch change
    },
    activeColor: Colors.green, // Set the color when the switch is on
    inactiveThumbColor: Colors.red, // Set the color when the switch is off
    // Optionally, set the track color as well
    activeTrackColor: Colors.green[200],
    inactiveTrackColor: Colors.red[200],
  );
}
