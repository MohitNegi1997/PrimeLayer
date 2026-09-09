import 'package:flutter/material.dart';

class DashboardChartLegend extends StatelessWidget {
  const DashboardChartLegend({
    super.key,
    required this.labels,
    required this.colors,
  });

  final List<String> labels;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colors[i],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(labels[i], style: theme.textTheme.bodySmall),
            ],
          ),
      ],
    );
  }
}
