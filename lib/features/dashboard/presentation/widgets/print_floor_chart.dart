import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_print_bar.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_chart_legend.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_chart_palette.dart';

class PrintFloorChart extends StatelessWidget {
  const PrintFloorChart({super.key, required this.bars});

  final List<DashboardPrintBar> bars;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labelStyle = theme.textTheme.bodySmall;
    final queuedColor = DashboardChartPalette.queued(scheme);
    final printingColor = DashboardChartPalette.printing(scheme);
    final failedColor = DashboardChartPalette.failed(scheme);
    final maxValue = bars
        .map((bar) => bar.total)
        .fold<double>(0, (max, value) => value > max ? value : max);

    return Column(
      children: [
        DashboardChartLegend(
          labels: const ['Queued', 'Printing', 'Failed'],
          colors: [queuedColor, printingColor, failedColor],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxValue * 1.2,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: theme.dividerColor,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      rod.toY.toInt().toString(),
                      theme.textTheme.bodySmall!.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    );
                  },
                ),
              ),
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
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index != value || index < 0 || index >= bars.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(bars[index].label, style: labelStyle),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == meta.max) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          value.toInt().toString(),
                          style: labelStyle,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < bars.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: bars[i].total,
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                        rodStackItems: [
                          BarChartRodStackItem(
                            0,
                            bars[i].queued,
                            queuedColor,
                          ),
                          BarChartRodStackItem(
                            bars[i].queued,
                            bars[i].queued + bars[i].printing,
                            printingColor,
                          ),
                          BarChartRodStackItem(
                            bars[i].queued + bars[i].printing,
                            bars[i].total,
                            failedColor,
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
