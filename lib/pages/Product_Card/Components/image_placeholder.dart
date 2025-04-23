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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set initial loading state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLoadingChanged(_isLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          bool newLoadingState = loadingProgress != null;
          if (newLoadingState != _isLoading) {
            _isLoading = newLoadingState;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onLoadingChanged(_isLoading);
            });
          }

          if (loadingProgress == null) {
            return child;
          }

          return Container(
            height: 300,
            color: Colors.grey[200],
            child: Center(
              child: Container(height: 20, width: 20),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (_isLoading) {
            _isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onLoadingChanged(false);
            });
          }

          return Container(
            height: 300,
            color: Colors.grey[200],
            child: Center(child: Text('Image could not be loaded')),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Ensure we're not loading when component is disposed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLoadingChanged(false);
    });
    super.dispose();
  }
}
