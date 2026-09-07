import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';

class PrinterLoaderPainter extends CustomPainter {
  const PrinterLoaderPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = (w * 0.018).clamp(1.4, 2.2)
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final bedTop = h * 0.86;
    final bedHeight = h * 0.055;
    final bedWidth = w * 0.78;
    final bedLeft = (w - bedWidth) / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bedLeft, bedTop, bedWidth, bedHeight),
        Radius.circular(w * 0.02),
      ),
      Paint()..color = AppColors.outline,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bedLeft, bedTop, bedWidth, bedHeight),
        Radius.circular(w * 0.02),
      ),
      stroke,
    );

    const layerCount = 3;
    final layerHeight = h * 0.075;
    final layerGap = h * 0.012;
    final layerWidths = [w * 0.52, w * 0.4, w * 0.28];
    final scaled = (progress * layerCount).clamp(0.0, layerCount.toDouble());
    final currentIndex = scaled.floor().clamp(0, layerCount - 1);
    final layerFill = (scaled - currentIndex).clamp(0.0, 1.0);

    var printX = w / 2;
    var printY = bedTop;

    for (var i = 0; i < layerCount; i++) {
      final fill = i < currentIndex
          ? 1.0
          : (i == currentIndex ? layerFill : 0.0);
      if (fill <= 0) continue;
      final layerWidth = layerWidths[i] * fill;
      final left = (w - layerWidths[i]) / 2;
      final top = bedTop - ((i + 1) * (layerHeight + layerGap));
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, layerWidth, layerHeight),
        Radius.circular(w * 0.015),
      );
      canvas.drawRRect(rect, Paint()..color = AppColors.accent);
      canvas.drawRRect(rect, stroke);
      printX = left + layerWidth;
      printY = top;
    }

    final headWidth = w * 0.34;
    final headHeight = h * 0.16;
    final headTop = h * 0.08;
    final headLeft = (printX - headWidth / 2).clamp(
      w * 0.08,
      w - headWidth - w * 0.08,
    );
    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(headLeft, headTop, headWidth, headHeight),
      Radius.circular(w * 0.03),
    );
    canvas.drawRRect(headRect, Paint()..color = AppColors.accent);
    canvas.drawRRect(headRect, stroke);

    final windowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(headLeft + headWidth / 2, headTop + headHeight * 0.42),
        width: headWidth * 0.46,
        height: headHeight * 0.28,
      ),
      Radius.circular(w * 0.012),
    );
    canvas.drawRRect(windowRect, Paint()..color = AppColors.surfaceLight);
    canvas.drawRRect(windowRect, stroke);

    final nozzleTop = headTop + headHeight;
    final nozzleBottom = printY;
    final nozzlePath = Path()
      ..moveTo(headLeft + headWidth * 0.28, nozzleTop)
      ..lineTo(headLeft + headWidth * 0.72, nozzleTop)
      ..lineTo(printX, nozzleTop + h * 0.12)
      ..close();
    canvas.drawPath(nozzlePath, Paint()..color = AppColors.primary);
    canvas.drawPath(nozzlePath, stroke);

    final tip = Offset(printX, nozzleTop + h * 0.12);
    final filament = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = (w * 0.016).clamp(1.5, 2.4)
      ..strokeCap = StrokeCap.round;
    if (nozzleBottom > tip.dy) {
      canvas.drawLine(tip, Offset(printX, nozzleBottom), filament);
    }
    canvas.drawCircle(tip, w * 0.018, Paint()..color = AppColors.secondary);
  }

  @override
  bool shouldRepaint(covariant PrinterLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
