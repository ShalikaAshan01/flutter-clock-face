import 'dart:math';

import 'package:flutter/cupertino.dart';

class ClockThick extends CustomPainter {
  final int second;
  final Color tickColor;
  final Color tickColorHighlight;

  ClockThick({this.second, this.tickColor, this.tickColorHighlight});

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 20;

    // Clock radius
    final r = size.shortestSide / 2 - padding;

    // tick
    final tickLen = 10;
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 5.0;

    final p = size.width * 0.56;

    for (int i = 1; i <= 60; i++) {
      double angleFrom12 = i / 60.0 * 2.0 * pi;
      double angleFrom3 = pi / 2.0 - angleFrom12;

      tickPaint.color = tickColor;
      if (second == 60 - i) tickPaint.color = tickColorHighlight;

      canvas.drawLine(
          size.center(Offset(cos(angleFrom3) * (r + tickLen - p),
              sin(angleFrom3) * (r + tickLen - p))),
          size.center(
              Offset(cos(angleFrom3) * (r - p), sin(angleFrom3) * (r - p))),
          tickPaint);
    }
  }

  @override
  bool shouldRepaint(ClockThick oldDelegate) {
    return oldDelegate.second != second;
  }
}
