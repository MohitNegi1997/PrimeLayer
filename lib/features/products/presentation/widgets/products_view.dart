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
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_state.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_visibility_filter.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_state.dart';
import 'package:primelayer_admin_panel/features/products/presentation/widgets/product_delete_dialog.dart';
import 'package:primelayer_admin_panel/features/products/presentation/widgets/product_editor_dialog.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listenWhen: (previous, current) => current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(notice)));
        context.read<ProductsCubit>().clearNotice();
      },
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, categoriesState) {
          return BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              final items = state.pagedProducts;
              return AdminListScaffold(
                title: 'Products',
                subtitle: 'Manage catalog items, variants, and website visibility.',
                actions: [
                  ElevatedButton.icon(
                    onPressed: () => ProductEditorDialog.open(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add product'),
                  ),
                ],
                stats: _stats(state),
                filters: _filters(context, state, categoriesState.categories),
                columns: const [
                  AdminTableColumn(label: 'Product', flex: 3),
                  AdminTableColumn(label: 'Category'),
                  AdminTableColumn(label: 'Variants'),
                  AdminTableColumn(label: 'Price'),
                  AdminTableColumn(label: 'Stock'),
                  AdminTableColumn(label: 'Status'),
                  AdminTableColumn(label: 'Actions', flex: 1),
                ],
                rowCount: items.length,
                cells: (index) => _cells(
                  context,
                  items[index],
                  categoriesState.categories,
                ),
                onRowTap: (index) => ProductEditorDialog.open(
                  context,
                  product: items[index],
                ),
                emptyLabel: state.query.trim().isEmpty
                    ? 'No products yet'
                    : 'No matching products',
                page: state.safePage,
                total: state.filteredProducts.length,
                onPageChanged: context.read<ProductsCubit>().pageChanged,
              );
            },
          );
        },
      ),
    );
  }

  List<AdminStatMetric> _stats(ProductsState state) {
    var visible = 0;
    var hidden = 0;
    var low = 0;
    for (final product in state.products) {
      if (product.isVisible) {
        visible += 1;
      } else {
        hidden += 1;
      }
      if (product.totalStock <= 5) low += 1;
    }
    return [
      AdminStatMetric(
        label: 'Total products',
        value: '${state.products.length}',
        caption: 'In catalog',
        icon: Icons.inventory_2_outlined,
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
        value: '$hidden',
        caption: 'Off website',
        icon: Icons.visibility_off_outlined,
        tone: AdminChipTone.muted,
      ),
      AdminStatMetric(
        label: 'Low stock',
        value: '$low',
        caption: 'Need a restock',
        icon: Icons.warning_amber_outlined,
        tone: AdminChipTone.pending,
      ),
    ];
  }

  List<Widget> _filters(
    BuildContext context,
    ProductsState state,
    List<Category> categories,
  ) {
    final cubit = context.read<ProductsCubit>();
    final selectedCategory =
        state.categoryId != null &&
            categories.any((item) => item.id == state.categoryId)
        ? state.categoryId!
        : 'all';
    return [
      AdminSearchField(hint: 'Search by name or slug', onChanged: cubit.searchChanged),
      AdminSelectField(
        label: 'Category',
        value: selectedCategory,
        options: [
          const AdminSelectOption(value: 'all', label: 'All categories'),
          for (final category in categories)
            AdminSelectOption(value: category.id, label: category.name),
        ],
        onChanged: (value) => cubit.categoryFilterChanged(
          value == 'all' ? null : value,
        ),
      ),
      AdminSelectField(
        label: 'Status',
        value: state.filter.name,
        options: [
          for (final value in ProductVisibilityFilter.values)
            AdminSelectOption(value: value.name, label: value.label),
        ],
        onChanged: (value) => cubit.filterChanged(
          ProductVisibilityFilter.values.firstWhere((item) => item.name == value),
        ),
      ),
    ];
  }

  List<Widget> _cells(
    BuildContext context,
    Product product,
    List<Category> categories,
  ) {
    return [
      Row(
        children: [
          MediaThumb(
            url: product.imageUrl,
            bytes: product.imageBytes,
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(width: 12),
          Expanded(child: AdminTextCell(product.name, emphasis: true)),
        ],
      ),
      AdminTextCell(_categoryName(categories, product.categoryId)),
      AdminTextCell(product.variantLabel),
      AdminTextCell(product.priceLabel),
      AdminTextCell('${product.totalStock}'),
      StatusChip(
        label: product.isVisible ? 'Visible' : 'Hidden',
        tone: product.isVisible ? AdminChipTone.success : AdminChipTone.muted,
      ),
      AdminRowMenu(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              ProductEditorDialog.open(context, product: product);
            case 'visibility':
              context.read<ProductsCubit>().toggleVisibility(product.id);
            case 'delete':
              ProductDeleteDialog.open(context, product);
          }
        },
        items: [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(
            value: 'visibility',
            child: Text(product.isVisible ? 'Hide' : 'Show'),
          ),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ];
  }

  String _categoryName(List<Category> categories, String id) {
    for (final category in categories) {
      if (category.id == id) return category.name;
    }
    return 'Uncategorized';
  }
}
