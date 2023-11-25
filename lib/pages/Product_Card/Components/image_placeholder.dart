import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Text('Image Placeholder', style: TextStyle(fontSize: 24)),
    );
  }
}
