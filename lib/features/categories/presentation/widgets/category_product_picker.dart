import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/categories/domain/catalog_product.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/category_form_cubit.dart';

class CategoryProductPicker extends StatelessWidget {
  const CategoryProductPicker({
    super.key,
    required this.products,
    required this.selectedIds,
  });

  final List<CatalogProduct> products;
  final List<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (products.isEmpty) {
      return Text('No products yet', style: theme.textTheme.bodyMedium);
    }

    return Column(
      children: [
        for (final product in products)
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: selectedIds.contains(product.id),
            title: Text(product.name),
            onChanged: (_) {
              context.read<CategoryFormCubit>().toggleProduct(product.id);
            },
          ),
      ],
    );
  }
}
