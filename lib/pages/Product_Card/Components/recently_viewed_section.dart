import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class RecentlyViewedSection extends StatefulWidget {
  final List<Map<String, String>> recentlyViewedDetails;
  final Function(int) onThumbnailTap;
  final Function(bool) onLoadingChanged;

  const RecentlyViewedSection({
    Key? key,
    required this.recentlyViewedDetails,
    required this.onThumbnailTap,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<RecentlyViewedSection> createState() => _RecentlyViewedSectionState();
}

class _RecentlyViewedSectionState extends State<RecentlyViewedSection> {
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
            imageDetails: widget.recentlyViewedDetails,
            selectedImageIndex: -1,
            onThumbnailTap: widget.onThumbnailTap,
          ),
        ],
      ),
    );
  }
}
