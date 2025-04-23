import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:flutter/material.dart';

class MoreColoursSection extends StatefulWidget {
  final List<Map<String, String>> imageDetails;
  final int selectedParentImageIndex;
  final Function(int) onThumbnailTap;
  final Function(bool) onLoadingChanged;

  const MoreColoursSection({
    Key? key,
    required this.imageDetails,
    required this.selectedParentImageIndex,
    required this.onThumbnailTap,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<MoreColoursSection> createState() => _MoreColoursSectionState();
}

class _MoreColoursSectionState extends State<MoreColoursSection> {
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
    // If we have 1 or no images, don't show more colors section
    if (widget.imageDetails.length <= 1) {
      return Container();
    }

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
            imageDetails: widget.imageDetails,
            selectedImageIndex: widget.selectedParentImageIndex,
            onThumbnailTap: widget.onThumbnailTap,
          ),
        ],
      ),
    );
  }
}
