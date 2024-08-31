import 'package:dyota/pages/Product_Card/Components/image_placeholder.dart';
import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> allImageUrls;
  final int selectedImageIndex;
  final Function(int) onThumbnailTap;

  const ImageCarousel({
    Key? key,
    required this.allImageUrls,
    required this.selectedImageIndex,
    required this.onThumbnailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImagePlaceholder(imageUrl: allImageUrls[selectedImageIndex]),
        ImageThumbnails(
          imageDetails: allImageUrls
              .map((url) => {'imageUrl': url, 'documentId': ''})
              .toList(),
          selectedImageIndex: selectedImageIndex,
          onThumbnailTap: onThumbnailTap,
        ),
      ],
    );
  }
}
