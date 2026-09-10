import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_visibility_filter.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';

class ProductsToolbar extends StatelessWidget {
  const ProductsToolbar({
    super.key,
    required this.filter,
    required this.categoryId,
    required this.categories,
    required this.onAdd,
  });

  final ProductVisibilityFilter filter;
  final String? categoryId;
  final List<Category> categories;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final title = Text('Products', style: theme.textTheme.titleLarge);
    final addButton = ElevatedButton.icon(
      onPressed: onAdd,
      icon: const Icon(Icons.add),
      label: const Text('Add product'),
    );
    final search = TextField(
      onChanged: context.read<ProductsCubit>().searchChanged,
      decoration: const InputDecoration(
        labelText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );
    final selectedCategoryId =
        categoryId != null &&
            categories.any((item) => item.id == categoryId)
        ? categoryId
        : 'all';
    final categoryFilter = DropdownButtonFormField<String>(
      key: ValueKey(selectedCategoryId),
      initialValue: selectedCategoryId,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Category'),
      items: [
        const DropdownMenuItem(value: 'all', child: Text('All categories')),
        for (final category in categories)
          DropdownMenuItem(value: category.id, child: Text(category.name)),
      ],
      onChanged: (value) {
        context.read<ProductsCubit>().categoryFilterChanged(
          value == 'all' ? null : value,
        );
      },
    );
    final toggle = SegmentedButton<ProductVisibilityFilter>(
      segments: [
        for (final value in ProductVisibilityFilter.values)
          ButtonSegment<ProductVisibilityFilter>(
            value: value,
            label: Text(value.label),
          ),
      ],
      selected: {filter},
      showSelectedIcon: false,
      onSelectionChanged: (selection) {
        context.read<ProductsCubit>().filterChanged(selection.first);
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
          categoryFilter,
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
            SizedBox(width: 220, child: categoryFilter),
            const SizedBox(width: 16),
            toggle,
          ],
        ),
      ],
    );
  }
}
