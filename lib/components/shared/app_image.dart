import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Cached network image with consistent error/placeholder handling.
class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? semanticLabel;

  const AppImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (ctx, __) => Container(
        width: width,
        height: height,
        color: Theme.of(ctx).colorScheme.surfaceVariant,
      ),
      errorWidget: (ctx, __, ___) => Container(
        width: width,
        height: height,
        color: Theme.of(ctx).colorScheme.surfaceVariant,
        child: Icon(Icons.broken_image, color: Theme.of(ctx).colorScheme.onSurfaceVariant),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
