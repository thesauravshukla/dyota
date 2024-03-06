import 'dart:io';

import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Settings/Components/password_change_modal.dart';
import 'package:dyota/pages/Settings/Components/personal_information_header.dart';
import 'package:dyota/pages/Settings/Components/section_title.dart';
import 'package:dyota/pages/Settings/Components/switch_list_tile.dart';
import 'package:dyota/pages/Settings/Components/textfield_section.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController dateController = TextEditingController();
  String? _profilePhotoUrl;

  void _showChangePasswordModal(BuildContext context) {
    PasswordChangeModal.show(context, onSave: () {
      Navigator.pop(context); // Implement your save logic
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage
          .ref()
          .child('profilePhotos/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask;
      String imageUrl = await ref.getDownloadURL();
      setState(() {
        _profilePhotoUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Settings'),
      body: ListView(
        children: [
          GestureDetector(
            onTap: _pickAndUploadImage,
            child: _profilePhotoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_profilePhotoUrl!),
                    radius: 60,
                  )
                : CircleAvatar(
                    child: Icon(Icons.account_circle, size: 60),
                    radius: 60,
                  ),
          ),
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
          const SectionTitle(title: 'Notifications'),
          SwitchListTileSection(context, 'Sales', true),
          SwitchListTileSection(context, 'New arrivals', false),
          SwitchListTileSection(context, 'Delivery status changes', false),
        ],
      ),
    );
  }
}
