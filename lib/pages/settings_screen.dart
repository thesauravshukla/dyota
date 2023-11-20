import 'package:dyota/components/password_change_modal.dart';
import 'package:dyota/components/personal_information_header.dart';
import 'package:dyota/components/section_title.dart';
import 'package:dyota/components/settings_appbar.dart';
import 'package:dyota/components/switch_list_tile.dart';
import 'package:dyota/components/textfield_section.dart';
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
      appBar: SettingsAppBar(),
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
