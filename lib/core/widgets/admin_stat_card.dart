import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';

class AdminStatCard extends StatelessWidget {
  const AdminStatCard({super.key, required this.metric});

  final AdminStatMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final fill = switch (metric.tone) {
      AdminChipTone.pending =>
        dark ? AppColors.warningSoftDark : AppColors.warningSoft,
      AdminChipTone.success =>
        dark ? AppColors.successSoftDark : AppColors.successSoft,
      AdminChipTone.danger =>
        dark ? AppColors.dangerSoftDark : AppColors.dangerSoft,
      AdminChipTone.info => dark ? AppColors.infoSoftDark : AppColors.infoSoft,
      AdminChipTone.muted => theme.colorScheme.tertiary.withValues(alpha: 0.35),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: fill,
              foregroundColor: theme.colorScheme.primary,
              child: Icon(metric.icon, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(metric.value, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 2),
                  Text(metric.caption, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
