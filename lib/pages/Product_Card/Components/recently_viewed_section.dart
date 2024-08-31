import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class RecentlyViewedSection extends StatelessWidget {
  final List<Map<String, String>> recentlyViewedDetails;
  final Function(int) onThumbnailTap;

  const RecentlyViewedSection({
    Key? key,
    required this.recentlyViewedDetails,
    required this.onThumbnailTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recently Viewed',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ImageThumbnails(
            imageDetails: recentlyViewedDetails,
            selectedImageIndex: -1,
            onThumbnailTap: onThumbnailTap,
          ),
        ],
      ),
    );
  }
}
