import 'package:dyota/components/shared/app_image.dart';
import 'package:flutter/material.dart';

class ImagePlaceholder extends StatefulWidget {
  final String imageUrl;
  final Function(bool) onLoadingChanged;

  const ImagePlaceholder({
    Key? key,
    required this.imageUrl,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  @override
  void initState() {
    super.initState();
    // CachedNetworkImage handles its own loading; notify parent after frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLoadingChanged(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppImage(url: widget.imageUrl),
    );
  }
}
