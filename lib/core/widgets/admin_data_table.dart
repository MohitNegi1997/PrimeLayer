import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';

class AdminDataTable extends StatelessWidget {
  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rowCount,
    required this.cells,
    this.onRowTap,
    this.onReorder,
    this.rowId,
    this.emptyLabel = 'No data yet',
  });

  final List<AdminTableColumn> columns;
  final int rowCount;
  final List<Widget> Function(int index) cells;
  final void Function(int index)? onRowTap;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final String Function(int index)? rowId;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: rowCount == 0
          ? Center(child: Text(emptyLabel, style: theme.textTheme.bodyMedium))
          : LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth < 960
                    ? 960.0
                    : constraints.maxWidth;
                final height = constraints.maxHeight.isFinite
                    ? constraints.maxHeight
                    : 400.0;
                return Scrollbar(
                  thumbVisibility: constraints.maxWidth < 960,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Column(
                        children: [
                          _header(theme),
                          Divider(height: 1, color: theme.dividerColor),
                          Expanded(child: _body(context, theme)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _header(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          for (final column in columns)
            Expanded(
              flex: column.flex,
              child: Text(
                column.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ThemeData theme) {
    final rows = [
      for (var index = 0; index < rowCount; index++) ...[
        if (index > 0) Divider(height: 1, color: theme.dividerColor),
        _row(
          context,
          index,
          key: onReorder == null
              ? null
              : ValueKey(rowId?.call(index) ?? '$index'),
        ),
      ],
    ];

    if (onReorder != null) {
      return SingleChildScrollView(
        child: ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          onReorder: onReorder!,
          children: [
            for (var index = 0; index < rowCount; index++)
              _row(
                context,
                index,
                key: ValueKey(rowId?.call(index) ?? '$index'),
              ),
          ],
        ),
      );
    }

    return SingleChildScrollView(child: Column(children: rows));
  }

  Widget _row(BuildContext context, int index, {Key? key}) {
    final rowCells = cells(index);
    final child = InkWell(
      onTap: onRowTap == null ? null : () => onRowTap!(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            for (var i = 0; i < columns.length; i++)
              Expanded(flex: columns[i].flex, child: rowCells[i]),
          ],
        ),
      ),
    );
    if (key == null) return child;
    return KeyedSubtree(key: key, child: child);
  }
}
