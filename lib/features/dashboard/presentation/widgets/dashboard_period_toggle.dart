import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/cubit/dashboard_period.dart';

class DashboardPeriodToggle extends StatelessWidget {
  const DashboardPeriodToggle({
    super.key,
    required this.period,
    required this.onChanged,
  });

  final DashboardPeriod period;
  final ValueChanged<DashboardPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DashboardPeriod>(
      segments: [
        for (final value in DashboardPeriod.values)
          ButtonSegment<DashboardPeriod>(
            value: value,
            label: Text(value.label),
          ),
      ],
      selected: {period},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
