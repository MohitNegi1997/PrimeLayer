import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_list_scaffold.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_row_menu.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_search_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_select_field.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_stat_metric.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_table_column.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_text_cell.dart';
import 'package:primelayer_admin_panel/core/widgets/media_thumb.dart';
import 'package:primelayer_admin_panel/core/widgets/status_chip.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_icons.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_visibility_filter.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_state.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/category_delete_dialog.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/category_editor_dialog.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_state.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesCubit, CategoriesState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<CategoriesCubit>().clearNotice();
      },
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, productsState) {
          return BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              final items = state.filteredCategories;
              var visible = 0;
              for (final category in state.categories) {
                if (category.isVisible) visible += 1;
              }
              return AdminListScaffold(
                title: 'Categories',
                subtitle: 'Organize products and control what the storefront shows.',
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => CategoryEditorDialog.open(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add category'),
                  ),
                ],
                stats: [
                  AdminStatMetric(
                    label: 'Total categories',
                    value: '${state.categories.length}',
                    caption: 'In catalog',
                    icon: Icons.category_outlined,
                  ),
                  AdminStatMetric(
                    label: 'Visible',
                    value: '$visible',
                    caption: 'On website',
                    icon: Icons.visibility_outlined,
                    tone: AdminChipTone.success,
                  ),
                  AdminStatMetric(
                    label: 'Hidden',
                    value: '${state.categories.length - visible}',
                    caption: 'Off website',
                    icon: Icons.visibility_off_outlined,
                    tone: AdminChipTone.muted,
                  ),
                  AdminStatMetric(
                    label: 'With products',
                    value: '${[
                      for (final category in state.categories)
                        if (productsState.countInCategory(category.id) > 0)
                          category,
                    ].length}',
                    caption: 'Assigned',
                    icon: Icons.inventory_2_outlined,
                    tone: AdminChipTone.info,
                  ),
                ],
                filters: [
                  AdminSearchField(
                    hint: 'Search by name or slug',
                    onChanged: context.read<CategoriesCubit>().searchChanged,
                  ),
                  AdminSelectField(
                    label: 'Status',
                    value: state.filter.name,
                    options: [
                      for (final value in CategoryVisibilityFilter.values)
                        AdminSelectOption(value: value.name, label: value.label),
                    ],
                    onChanged: (value) {
                      context.read<CategoriesCubit>().filterChanged(
                        CategoryVisibilityFilter.values.firstWhere(
                          (item) => item.name == value,
                        ),
                      );
                    },
                  ),
                ],
                columns: const [
                  AdminTableColumn(label: 'Category', flex: 3),
                  AdminTableColumn(label: 'Slug'),
                  AdminTableColumn(label: 'Products'),
                  AdminTableColumn(label: 'Status'),
                  AdminTableColumn(label: 'Actions', flex: 1),
                ],
                rowCount: items.length,
                rowId: (index) => items[index].id,
                onReorder: state.canReorder
                    ? context.read<CategoriesCubit>().reorder
                    : null,
                cells: (index) => _cells(
                  context,
                  items[index],
                  productsState.countInCategory(items[index].id),
                ),
                onRowTap: (index) => CategoryEditorDialog.open(
                  context,
                  category: items[index],
                ),
                emptyLabel: state.query.trim().isEmpty
                    ? 'No categories yet'
                    : 'No matching categories',
                page: 0,
                total: items.length,
                onPageChanged: (_) {},
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _cells(
    BuildContext context,
    Category category,
    int productCount,
  ) {
    return [
      Row(
        children: [
          MediaThumb(
            url: category.imageUrl,
            bytes: category.imageBytes,
            icon: CategoryIcons.data(category.iconKey),
          ),
          const SizedBox(width: 12),
          Expanded(child: AdminTextCell(category.name, emphasis: true)),
        ],
      ),
      AdminTextCell('/${category.slug}'),
      AdminTextCell(productCount == 1 ? '1 product' : '$productCount products'),
      StatusChip(
        label: category.isVisible ? 'Visible' : 'Hidden',
        tone: category.isVisible ? AdminChipTone.success : AdminChipTone.muted,
      ),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              CategoryEditorDialog.open(context, category: category);
            case 'visibility':
              context.read<CategoriesCubit>().toggleVisibility(category.id);
            case 'delete':
              CategoryDeleteDialog.open(context, category);
          }
        },
        items: [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(
            value: 'visibility',
            child: Text(category.isVisible ? 'Hide' : 'Show'),
          ),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }
}
