import 'package:dyota/components/section_title.dart';
import 'package:flutter/material.dart';

class DeliveryMethodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This should be dynamically generated based on available delivery methods
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Delivery method'),
          // Use a GridView.builder or similar here
        ],
      ),
    );
  }
}
