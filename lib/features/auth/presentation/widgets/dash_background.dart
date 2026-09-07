import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/auth/presentation/widgets/dash_pattern_painter.dart';

class DashBackground extends StatelessWidget {
  const DashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: DashPatternPainter(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
        size: Size.infinite,
      ),
    );
  }
}
