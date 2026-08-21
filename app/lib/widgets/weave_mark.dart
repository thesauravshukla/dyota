import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Dyota mark: two warp threads crossing two weft, interlaced.
///
/// Drawn rather than shipped as an asset — it is six straight strokes, so a
/// painter stays crisp at every size from a 1024px icon down to 18px in a bar,
/// and adds no SVG dependency.
class WeaveMark extends StatelessWidget {
  const WeaveMark({super.key, this.size = 48, this.colour});

  final double size;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _WeavePainter(colour ?? AppColors.ink),
      ),
    );
  }
}

class _WeavePainter extends CustomPainter {
  _WeavePainter(this.colour);

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    // Authored on a 100x100 grid, scaled to whatever we are given.
    final k = size.width / 100;
    final paint = Paint()
      ..color = colour
      ..strokeWidth = 9 * k
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset p(double x, double y) => Offset(x * k, y * k);
    void line(double x1, double y1, double x2, double y2) =>
        canvas.drawLine(p(x1, y1), p(x2, y2), paint);

    // Each thread BREAKS where it passes under another. Drawing one stroke on
    // top of another in the same ink shows nothing — the gap is the only thing
    // that makes an interlace read as woven rather than as a grid.
    //
    // Crossings alternate: warp over weft at (38,38) and (62,62), weft over
    // warp at (62,38) and (38,62).
    line(38, 18, 38, 54);   // warp 1, unbroken through the first weft
    line(38, 70, 38, 82);   //         resumes below the second weft
    line(62, 18, 62, 30);   // warp 2, breaks at the first weft
    line(62, 46, 62, 82);
    line(18, 38, 30, 38);   // weft 1, breaks at the first warp
    line(46, 38, 82, 38);
    line(18, 62, 54, 62);   // weft 2, unbroken across the first warp
    line(70, 62, 82, 62);
  }

  @override
  bool shouldRepaint(_WeavePainter old) => old.colour != colour;
}

/// Mark plus wordmark, used on the sign-in screen and the launch screen.
class WeaveLockup extends StatelessWidget {
  const WeaveLockup({super.key, this.markSize = 40, this.axis = Axis.horizontal});

  final double markSize;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final word = Text('DYOTA', style: Theme.of(context).textTheme.headlineSmall);
    final mark = WeaveMark(size: markSize);

    return axis == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: [mark, const SizedBox(width: 14), word])
        : Column(mainAxisSize: MainAxisSize.min, children: [mark, const SizedBox(height: 16), word]);
  }
}
