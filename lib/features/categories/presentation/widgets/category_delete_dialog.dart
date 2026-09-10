import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';

abstract final class CategoryDeleteDialog {
  static Future<void> open(BuildContext context, Category category) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete ${category.name}?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CategoriesCubit>().delete(
                  category.id,
                  productCount: context
                      .read<ProductsCubit>()
                      .state
                      .countInCategory(category.id),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
