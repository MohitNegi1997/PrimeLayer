import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashPatternPainter extends CustomPainter {
  const DashPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final random = math.Random(7);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final count = ((size.width * size.height) / 11000).clamp(48, 140).toInt();

    for (var i = 0; i < count; i++) {
      final start = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final length = 7 + random.nextDouble() * 8;
      final angle = -0.85 + (random.nextDouble() - 0.5) * 0.3;
      final end = Offset(
        start.dx + math.cos(angle) * length,
        start.dy + math.sin(angle) * length,
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DashPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
