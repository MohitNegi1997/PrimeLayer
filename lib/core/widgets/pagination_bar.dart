import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.page,
    required this.total,
    required this.onPageChanged,
  });

  final int page;
  final int total;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final pageCount = PageSlice.count(total);
    final start = total == 0 ? 0 : page * PageSlice.size + 1;
    final end = ((page + 1) * PageSlice.size).clamp(0, total);
    final pages = _visiblePages(pageCount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
      child: Responsive.isMobile(context)
          ? Column(
              children: [
                Text(
                  'Showing $start to $end of $total',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                _controls(theme, pageCount, pages),
              ],
            )
          : Row(
              children: [
                Text(
                  'Showing $start to $end of $total',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                _controls(theme, pageCount, pages),
              ],
            ),
    );
  }

  Widget _controls(ThemeData theme, int pageCount, List<int> pages) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Previous',
          onPressed: page == 0 ? null : () => onPageChanged(page - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        for (final index in pages)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _pageButton(theme, index),
          ),
        IconButton(
          tooltip: 'Next',
          onPressed: page >= pageCount - 1
              ? null
              : () => onPageChanged(page + 1),
          icon: const Icon(Icons.chevron_right),
        ),
        const SizedBox(width: 8),
        Text('${PageSlice.size} / page', style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _pageButton(ThemeData theme, int index) {
    final selected = index == page;
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onPageChanged(index),
          child: Center(
            child: Text(
              '${index + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<int> _visiblePages(int pageCount) {
    if (pageCount <= 5) {
      return [for (var i = 0; i < pageCount; i++) i];
    }
    var start = page - 1;
    if (start < 0) start = 0;
    var end = start + 3;
    if (end > pageCount - 1) {
      end = pageCount - 1;
      start = end - 3;
    }
    return [for (var i = start; i <= end; i++) i];
  }
}
