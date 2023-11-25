import 'package:dyota/pages/Settings/Components/build_password_field.dart';
import 'package:flutter/material.dart';

class PasswordChangeModal {
  static void show(BuildContext context, {required VoidCallback onSave}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Password Change',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildPasswordField(context, 'Old Password'),
              buildPasswordField(context, 'New Password'),
              buildPasswordField(context, 'Repeat New Password'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: onSave,
                child: Text('SAVE PASSWORD'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
