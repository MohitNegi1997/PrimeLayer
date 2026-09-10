import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_visibility_filter.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_state.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/categories_toolbar.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/category_delete_dialog.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/category_editor_dialog.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/category_tile.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

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
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          final items = state.filteredCategories;
          return Padding(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CategoriesToolbar(
                  filter: state.filter,
                  onAdd: () => CategoryEditorDialog.open(context),
                ),
                const SizedBox(height: 16),
                Expanded(child: _listCard(context, state, items)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _listCard(
    BuildContext context,
    CategoriesState state,
    List<Category> items,
  ) {
    final theme = Theme.of(context);
    final isUnfiltered =
        state.query.trim().isEmpty &&
        state.filter == CategoryVisibilityFilter.all;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: items.isEmpty
          ? Center(
              child: Text(
                isUnfiltered ? 'No categories yet' : 'No matching categories',
                style: theme.textTheme.bodyMedium,
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              buildDefaultDragHandles: false,
              onReorder: context.read<CategoriesCubit>().reorder,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final category = items[index];
                return Opacity(
                  key: ValueKey(category.id),
                  opacity: category.isVisible ? 1 : 0.55,
                  child: CategoryTile(
                    category: category,
                    index: index,
                    showDragHandle: state.canReorder,
                    onEdit: () =>
                        CategoryEditorDialog.open(context, category: category),
                    onToggleVisibility: (_) {
                      context.read<CategoriesCubit>().toggleVisibility(
                        category.id,
                      );
                    },
                    onDelete: () =>
                        CategoryDeleteDialog.open(context, category),
                  ),
                );
              },
            ),
    );
  }
}
