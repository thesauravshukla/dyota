import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class UsersAlsoViewedSection extends StatefulWidget {
  final List<Map<String, String>> usersAlsoViewedDetails;
  final Function(int) onThumbnailTap;
  final Function(bool) onLoadingChanged;

  const UsersAlsoViewedSection({
    Key? key,
    required this.usersAlsoViewedDetails,
    required this.onThumbnailTap,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<UsersAlsoViewedSection> createState() => _UsersAlsoViewedSectionState();
}

class _UsersAlsoViewedSectionState extends State<UsersAlsoViewedSection> {
  @override
  void initState() {
    super.initState();
    // This component isn't async, so notify it's not loading on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLoadingChanged(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
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
            imageDetails: widget.usersAlsoViewedDetails,
            selectedImageIndex: -1,
            onThumbnailTap: widget.onThumbnailTap,
          ),
        ],
      ),
    );
  }
}
