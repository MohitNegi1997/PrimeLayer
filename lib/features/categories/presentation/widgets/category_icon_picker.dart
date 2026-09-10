import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_icons.dart';

class CategoryIconPicker extends StatelessWidget {
  const CategoryIconPicker({
    super.key,
    required this.selectedKey,
    required this.onChanged,
  });

  final String selectedKey;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final key in CategoryIcons.keys)
          IconButton.outlined(
            tooltip: key,
            isSelected: key == selectedKey,
            style: IconButton.styleFrom(
              foregroundColor: key == selectedKey
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.secondary,
              backgroundColor: key == selectedKey
                  ? theme.colorScheme.primary
                  : null,
            ),
            onPressed: () => onChanged(key),
            icon: Icon(CategoryIcons.data(key)),
          ),
      ],
    );
  }
}
