import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_icons.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.index,
    required this.showDragHandle,
    required this.onEdit,
    required this.onToggleVisibility,
    required this.onDelete,
  });

  final Category category;
  final int index;
  final bool showDragHandle;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggleVisibility;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final productLabel = category.productCount == 1
        ? '1 product'
        : '${category.productCount} products';

    return ListTile(
      onTap: onEdit,
      minLeadingWidth: showDragHandle ? 88 : 40,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_indicator,
                color: theme.colorScheme.secondary,
              ),
            ),
          CircleAvatar(
            backgroundColor: theme.colorScheme.tertiary.withValues(alpha: 0.35),
            foregroundColor: theme.colorScheme.primary,
            child: Icon(CategoryIcons.data(category.iconKey)),
          ),
        ],
      ),
      title: Text(category.name, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '/${category.slug} · $productLabel',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMobile)
            Switch(value: category.isVisible, onChanged: onToggleVisibility),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                case 'visibility':
                  onToggleVisibility(!category.isVisible);
                case 'delete':
                  onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'visibility',
                child: Text(category.isVisible ? 'Hide' : 'Show'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
