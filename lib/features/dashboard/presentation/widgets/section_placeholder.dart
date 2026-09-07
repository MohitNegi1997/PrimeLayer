import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_nav_destination.dart';

class SectionPlaceholder extends StatelessWidget {
  const SectionPlaceholder({super.key, required this.destination});

  final DashboardNavDestination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                destination.icon,
                size: 48,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(destination.label, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('No data yet', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
