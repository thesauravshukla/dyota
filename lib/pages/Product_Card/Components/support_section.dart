import 'package:flutter/material.dart';

class SupportSection extends StatefulWidget {
  const SupportSection({super.key});

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  bool _showContact = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text('Support'),
            trailing: AnimatedRotation(
              duration: Duration(milliseconds: 200),
              turns: _showContact ? 0.5 : 0,
              child: Icon(Icons.keyboard_arrow_down),
            ),
            onTap: () {
              setState(() {
                _showContact = !_showContact;
              });
            },
          ),
          if (_showContact)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                'For support, contact: +91 9327058496',
                style: TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
