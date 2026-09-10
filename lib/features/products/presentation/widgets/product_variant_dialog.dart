import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_variant_form_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_variant_form_state.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';

class ProductVariantDialog extends StatelessWidget {
  const ProductVariantDialog({super.key});

  static Future<void> open(
    BuildContext context, {
    ProductVariant? variant,
  }) {
    final formCubit = context.read<ProductFormCubit>();
    final existingSkus = [
      for (final product in context.read<ProductsCubit>().state.products)
        if (product.id != formCubit.state.id)
          for (final item in product.variants) item.sku,
      for (final item in formCubit.state.variants)
        if (item.id != variant?.id) item.sku,
    ];

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: formCubit),
            BlocProvider(
              create: (_) => ProductVariantFormCubit(
                variant: variant,
                existingSkus: existingSkus,
              ),
            ),
          ],
          child: const ProductVariantDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<ProductVariantFormCubit>();
    final isEditing = formCubit.state.isEditing;

    return Dialog(
      child: BlocListener<ProductVariantFormCubit, ProductVariantFormState>(
        listenWhen: (previous, current) =>
            current.status == ProductVariantFormStatus.success,
        listener: (context, state) {
          context.read<ProductFormCubit>().saveVariant(state.toVariant());
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 440,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isEditing ? 'Edit variant' : 'Add variant',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: formCubit.state.name,
                    textInputAction: TextInputAction.next,
                    onChanged: formCubit.nameChanged,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: formCubit.state.sku,
                    textInputAction: TextInputAction.next,
                    onChanged: formCubit.skuChanged,
                    decoration: const InputDecoration(labelText: 'SKU'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: formCubit.state.price,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: formCubit.priceChanged,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: formCubit.state.size,
                    textInputAction: TextInputAction.next,
                    onChanged: formCubit.sizeChanged,
                    decoration: const InputDecoration(labelText: 'Size'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: formCubit.state.color,
                    textInputAction: TextInputAction.next,
                    onChanged: formCubit.colorChanged,
                    decoration: const InputDecoration(labelText: 'Color'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: formCubit.state.material,
                    textInputAction: TextInputAction.next,
                    onChanged: formCubit.materialChanged,
                    decoration: const InputDecoration(labelText: 'Material'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: formCubit.state.stock,
                    keyboardType: TextInputType.number,
                    onChanged: formCubit.stockChanged,
                    decoration: const InputDecoration(labelText: 'Stock'),
                  ),
                  _errorText(theme),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: formCubit.submit,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorText(ThemeData theme) {
    return BlocBuilder<ProductVariantFormCubit, ProductVariantFormState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.errorMessage == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            state.errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }
}
