import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_visibility_filter.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';

class CategoriesToolbar extends StatelessWidget {
  const CategoriesToolbar({
    super.key,
    required this.filter,
    required this.onAdd,
  });

  final CategoryVisibilityFilter filter;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final title = Text('Categories', style: theme.textTheme.titleLarge);
    final addButton = ElevatedButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add),
      label: const Text('Add category'),
    );
    final search = TextField(
      onChanged: context.read<CategoriesCubit>().searchChanged,
      decoration: const InputDecoration(
        labelText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );
    final toggle = SegmentedButton<CategoryVisibilityFilter>(
      segments: [
        for (final value in CategoryVisibilityFilter.values)
          ButtonSegment<CategoryVisibilityFilter>(
            value: value,
            label: Text(value.label),
          ),
      ],
      selected: {filter},
      showSelectedIcon: false,
      onSelectionChanged: (selection) {
        context.read<CategoriesCubit>().filterChanged(selection.first);
      },
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(height: 12),
          addButton,
          const SizedBox(height: 12),
          search,
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: toggle,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: title),
            addButton,
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: 16),
            toggle,
          ],
        ),
      ],
    );
  }
}
