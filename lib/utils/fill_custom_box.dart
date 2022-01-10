import 'package:flutter/material.dart';

class FillCustomBox extends CustomPainter {
  final double radius;
  final Color activeColor;
  final bool selected;

  FillCustomBox({
    required this.radius,
    required this.selected,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final offsetCenter = Offset(
      size.width / 2,
      size.height / 2,
    );

    final fillBox = Paint()
      ..color = activeColor
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    canvas.drawCircle(
      offsetCenter,
      offsetCenter.dx / 2,
      Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round,
    );

    if (selected == true)
      canvas.drawCircle(
        offsetCenter,
        radius,
        fillBox,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
