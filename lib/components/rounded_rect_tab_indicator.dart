import 'package:flutter/material.dart';

class PaddedRoundedRectTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final EdgeInsets padding;
  final double? width; // Optional fixed width

  PaddedRoundedRectTabIndicator({
    required this.color,
    required this.radius,
    required this.padding,
    required this.width,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _PaddedRRectPainter(
        color: color, radius: radius, padding: padding, width: width);
  }
}

class _PaddedRRectPainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  final EdgeInsets padding;
  final double? width; // Optional fixed width

  _PaddedRRectPainter({
    required Color color,
    required this.radius,
    required this.padding,
    this.width, // Accept the width parameter
  }) : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final double indicatorWidth = width ??
        configuration.size!.width -
            padding.left -
            padding.right; // Use the fixed width if provided
    final double horizontalOffset =
        (configuration.size!.width - indicatorWidth) /
            2; // Center the indicator within the tab

    final Rect rect =
        Offset(offset.dx + horizontalOffset, offset.dy + padding.top) &
            Size(indicatorWidth,
                configuration.size!.height - padding.top - padding.bottom);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rRect, _paint);
  }
}
