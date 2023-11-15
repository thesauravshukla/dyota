import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Text('Image Placeholder', style: TextStyle(fontSize: 24)),
    );
  }
}
