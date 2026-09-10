import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_card.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';

class AdminStatGrid extends StatelessWidget {
  const AdminStatGrid({super.key, required this.metrics});

  final List<AdminStatMetric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();
    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            AdminStatCard(metric: metrics[i]),
          ],
        ],
      );
    }

    final perRow = Responsive.isDesktop(context) ? 4 : 2;
    final rows = <List<AdminStatMetric>>[];
    for (var i = 0; i < metrics.length; i += perRow) {
      final end = (i + perRow).clamp(0, metrics.length);
      rows.add(metrics.sublist(i, end));
    }

    return Column(
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < perRow; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(
                  child: i < rows[r].length
                      ? AdminStatCard(metric: rows[r][i])
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
