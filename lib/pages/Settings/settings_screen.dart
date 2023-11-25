import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Settings/Components/password_change_modal.dart';
import 'package:dyota/pages/Settings/Components/personal_information_header.dart';
import 'package:dyota/pages/Settings/Components/section_title.dart';
import 'package:dyota/pages/Settings/Components/switch_list_tile.dart';
import 'package:dyota/pages/Settings/Components/textfield_section.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();

  void _showChangePasswordModal(BuildContext context) {
    PasswordChangeModal.show(context, onSave: () {
      Navigator.pop(context); // Implement your save logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Settings'),
      body: ListView(
        children: [
          PersonalInformationHeader(),
          TextFieldSection.buildTextFormField(context, 'Full name'),
          TextFieldSection.buildDateFormField(
              context, 'Date of Birth', dateController),
          SectionTitle(
            title: 'Password',
            onChange: () => _showChangePasswordModal(context),
          ),
          TextFieldSection.buildTextFormField(context, 'Password',
              isPassword: true),
          SectionTitle(
              title: 'Notifications'), // No 'onChange' for notifications
          SwitchListTileSection(context, 'Sales', true),
          SwitchListTileSection(context, 'New arrivals', false),
          SwitchListTileSection(context, 'Delivery status changes', false),
        ],
      ),
    );
  }
}
