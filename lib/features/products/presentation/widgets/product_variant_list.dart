import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_state.dart';
import 'package:primelayer_admin_panel/features/products/presentation/widgets/product_variant_dialog.dart';

class ProductVariantList extends StatelessWidget {
  const ProductVariantList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProductFormCubit, ProductFormState>(
      buildWhen: (previous, current) => previous.variants != current.variants,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Variants', style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: () => ProductVariantDialog.open(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add variant'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (state.variants.isEmpty)
              Text('No variants yet', style: theme.textTheme.bodyMedium)
            else
              for (final variant in state.variants) _tile(context, variant),
          ],
        );
      },
    );
  }

  Widget _tile(BuildContext context, ProductVariant variant) {
    final details = [
      variant.sku,
      variant.formattedPrice,
      '${variant.stock} in stock',
      if (variant.size != null) variant.size,
      if (variant.color != null) variant.color,
      if (variant.material != null) variant.material,
    ].join(' · ');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(variant.name),
      subtitle: Text(details),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () =>
                ProductVariantDialog.open(context, variant: variant),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () =>
                context.read<ProductFormCubit>().deleteVariant(variant.id),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
