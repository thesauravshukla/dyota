import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final String imageUrl;

  const ImagePlaceholder({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
