import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';

abstract final class ProductDeleteDialog {
  static Future<void> open(BuildContext context, Product product) {
    final variantNote = product.variantCount == 0
        ? 'This cannot be undone.'
        : 'This will also delete ${product.variantLabel}.';

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete ${product.name}?'),
          content: Text(variantNote),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProductsCubit>().delete(product.id);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
