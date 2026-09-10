import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = AdminChipTone.muted,
  });

  final String label;
  final AdminChipTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final fill = switch (tone) {
      AdminChipTone.pending =>
        dark ? AppColors.warningSoftDark : AppColors.warningSoft,
      AdminChipTone.success =>
        dark ? AppColors.successSoftDark : AppColors.successSoft,
      AdminChipTone.danger =>
        dark ? AppColors.dangerSoftDark : AppColors.dangerSoft,
      AdminChipTone.info => dark ? AppColors.infoSoftDark : AppColors.infoSoft,
      AdminChipTone.muted => theme.colorScheme.tertiary.withValues(alpha: 0.35),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
      ),
    );
  }
}
