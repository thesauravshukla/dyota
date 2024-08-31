import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class UsersAlsoViewedSection extends StatelessWidget {
  final List<Map<String, String>> usersAlsoViewedDetails;
  final Function(int) onThumbnailTap;

  const UsersAlsoViewedSection({
    Key? key,
    required this.usersAlsoViewedDetails,
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
              'Users Also Viewed',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ImageThumbnails(
            imageDetails: usersAlsoViewedDetails,
            selectedImageIndex: -1,
            onThumbnailTap: onThumbnailTap,
          ),
        ],
      ),
    );
  }
}
