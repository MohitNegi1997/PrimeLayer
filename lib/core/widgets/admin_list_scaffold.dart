import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_data_table.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_filter_bar.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_page_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/pagination_bar.dart';

class AdminListScaffold extends StatelessWidget {
  const AdminListScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
    this.stats = const [],
    this.filters = const [],
    this.leading,
    this.embedded = false,
    required this.columns,
    required this.rowCount,
    required this.cells,
    this.onRowTap,
    this.onReorder,
    this.rowId,
    this.emptyLabel = 'No data yet',
    required this.page,
    required this.total,
    required this.onPageChanged,
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;
  final List<AdminStatMetric> stats;
  final List<Widget> filters;
  final Widget? leading;
  final bool embedded;
  final List<AdminTableColumn> columns;
  final int rowCount;
  final List<Widget> Function(int index) cells;
  final void Function(int index)? onRowTap;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final String Function(int index)? rowId;
  final String emptyLabel;
  final int page;
  final int total;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return AdminPageScaffold(
      title: title,
      subtitle: subtitle,
      actions: actions,
      stats: stats,
      embedded: embedded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (filters.isNotEmpty) ...[
            AdminFilterBar(children: filters),
            const SizedBox(height: 16),
          ],
          if (leading != null) ...[leading!, const SizedBox(height: 16)],
          Expanded(
            child: AdminDataTable(
              columns: columns,
              rowCount: rowCount,
              cells: cells,
              onRowTap: onRowTap,
              onReorder: onReorder,
              rowId: rowId,
              emptyLabel: emptyLabel,
            ),
          ),
          PaginationBar(page: page, total: total, onPageChanged: onPageChanged),
        ],
      ),
    );
  }
}
