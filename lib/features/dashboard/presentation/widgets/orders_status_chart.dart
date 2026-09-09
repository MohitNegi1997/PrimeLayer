import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_chart_point.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_chart_legend.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_chart_palette.dart';

class OrdersStatusChart extends StatelessWidget {
  const OrdersStatusChart({super.key, required this.slices});

  final List<DashboardChartPoint> slices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = DashboardChartPalette.status(theme.colorScheme);
    final total = slices.fold<double>(0, (sum, slice) => sum + slice.value);

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 48,
              startDegreeOffset: -90,
              pieTouchData: PieTouchData(enabled: false),
              sections: [
                for (var i = 0; i < slices.length; i++)
                  PieChartSectionData(
                    value: slices[i].value,
                    color: colors[i],
                    radius: 36,
                    title: '',
                  ),
              ],
            ),
          ),
        ),
        Text(
          '${total.toInt()} orders',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        DashboardChartLegend(
          labels: [
            for (final slice in slices) '${slice.label} ${slice.value.toInt()}',
          ],
          colors: colors,
        ),
      ],
    );
  }
}
