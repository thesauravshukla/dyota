import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class MoreColoursSection extends StatelessWidget {
  final List<Map<String, String>> imageDetails;
  final int selectedParentImageIndex;
  final Function(int) onThumbnailTap;

  const MoreColoursSection({
    Key? key,
    required this.imageDetails,
    required this.selectedParentImageIndex,
    required this.onThumbnailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'More Colours',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ImageThumbnails(
            imageDetails: imageDetails,
            selectedImageIndex: selectedParentImageIndex,
            onThumbnailTap: onThumbnailTap,
          ),
        ],
      ),
    );
  }
}
