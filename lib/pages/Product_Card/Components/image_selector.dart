import 'package:dyota/components/shared/app_image.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const ImageSelector({
    Key? key,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: AppImage(
              url: imageUrl,
              width: 150,
              height: 150,
            ),
          ),
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.white, size: 30),
            ),
        ],
      ),
    );
  }
}
