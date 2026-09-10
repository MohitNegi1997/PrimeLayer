import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_header.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_grid.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';

class AdminPageScaffold extends StatelessWidget {
  const AdminPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
    this.stats = const [],
    this.embedded = false,
    this.child,
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;
  final List<AdminStatMetric> stats;
  final bool embedded;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final hasHeader = title.isNotEmpty;
    final hasActions = actions.isNotEmpty;

    return Padding(
      padding: embedded ? EdgeInsets.zero : EdgeInsets.all(isDesktop ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasHeader)
            AdminPageHeader(
              title: title,
              subtitle: subtitle,
              actions: actions,
            )
          else if (hasActions)
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(spacing: 8, runSpacing: 8, children: actions),
            ),
          if (stats.isNotEmpty) ...[
            if (hasHeader || hasActions) const SizedBox(height: 16),
            AdminStatGrid(metrics: stats),
          ],
          if (child != null) ...[
            const SizedBox(height: 16),
            Expanded(child: child!),
          ],
        ],
      ),
    );
  }
}
