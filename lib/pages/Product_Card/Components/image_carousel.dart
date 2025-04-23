import 'package:dyota/pages/Product_Card/Components/image_placeholder.dart';
import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> allImageUrls;
  final int selectedImageIndex;
  final Function(int) onThumbnailTap;
  final Function(bool) onLoadingChanged;

  const ImageCarousel({
    Key? key,
    required this.allImageUrls,
    required this.selectedImageIndex,
    required this.onThumbnailTap,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  void initState() {
    super.initState();
    // If we have no images, indicate that we're not loading via post-frame callback
    if (widget.allImageUrls.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onLoadingChanged(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we have no images, return an empty container
    if (widget.allImageUrls.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        ImagePlaceholder(
            imageUrl: widget.allImageUrls[widget.selectedImageIndex],
            onLoadingChanged: widget.onLoadingChanged),
        ImageThumbnails(
          imageDetails: widget.allImageUrls
              .map((url) => {'imageUrl': url, 'documentId': ''})
              .toList(),
          selectedImageIndex: widget.selectedImageIndex,
          onThumbnailTap: widget.onThumbnailTap,
        ),
      ],
    );
  }
}
