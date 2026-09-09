import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_chart_point.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key, required this.points});

  final List<DashboardChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall;
    final maxValue = points
        .map((point) => point.value)
        .fold<double>(0, (max, value) => value > max ? value : max);
    final maxY = maxValue * 1.2;
    final interval = points.length > 8 ? 5.0 : 1.0;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (points.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: theme.dividerColor,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: interval,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index != value ||
                    index < 0 ||
                    index >= points.length ||
                    (interval > 1 && index % interval.toInt() != 0)) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(points[index].label, style: labelStyle),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(_compact(value), style: labelStyle),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => theme.colorScheme.surface,
            getTooltipItems: (touchedSpots) {
              return [
                for (final spot in touchedSpots)
                  LineTooltipItem(
                    '₹${spot.y.toInt()}',
                    theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
              ];
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < points.length; i++)
                FlSpot(i.toDouble(), points[i].value),
            ],
            isCurved: true,
            preventCurveOverShooting: true,
            color: theme.colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: points.length <= 8),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.tertiary.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  static String _compact(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}k';
    }
    return value.toInt().toString();
  }
}
