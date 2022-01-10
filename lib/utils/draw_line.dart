import 'package:flutter/material.dart';

class DrawLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final offsetCenter = Offset(
      size.width / 2,
      size.height / 2,
    );

    final path = Path()
      ..moveTo(offsetCenter.dx - 1, offsetCenter.dy + 6)
      ..lineTo(offsetCenter.dx - 7, offsetCenter.dy - 2)
      ..moveTo(offsetCenter.dx - 1, offsetCenter.dy + 6)
      ..lineTo(offsetCenter.dx + 8, offsetCenter.dy - 5);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
