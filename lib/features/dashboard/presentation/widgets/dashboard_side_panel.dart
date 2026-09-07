import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primelayer_admin_panel/features/dashboard/presentation/widgets/dashboard_nav_destination.dart';

class DashboardSidePanel extends StatelessWidget {
  const DashboardSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.path;

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        children: [
          for (final item in DashboardNavDestination.all)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                selected: location == item.route,
                selectedColor: theme.colorScheme.primary,
                selectedTileColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.35,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: () {
                  final scaffold = Scaffold.maybeOf(context);
                  if (scaffold?.isDrawerOpen ?? false) {
                    scaffold!.closeDrawer();
                  }
                  context.go(item.route);
                },
              ),
            ),
        ],
      ),
    );
  }
}
