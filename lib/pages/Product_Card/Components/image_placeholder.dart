import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final String imageUrl;
  const ImagePlaceholder({Key? key, required this.imageUrl}) : super(key: key);

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
