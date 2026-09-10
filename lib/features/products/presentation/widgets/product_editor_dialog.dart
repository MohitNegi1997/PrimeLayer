import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/image_upload_field.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_state.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/widgets/product_variant_list.dart';

class ProductEditorDialog extends StatelessWidget {
  const ProductEditorDialog({super.key});

  static Future<void> open(BuildContext context, {Product? product}) {
    final productsCubit = context.read<ProductsCubit>();
    final categories = context.read<CategoriesCubit>().state.categories;
    final existingSlugs = [
      for (final item in productsCubit.state.products)
        if (item.id != product?.id) item.slug,
    ];
    final defaultCategoryId = product?.categoryId ??
        (categories.isEmpty ? '' : categories.first.id);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: productsCubit),
            BlocProvider.value(value: context.read<CategoriesCubit>()),
            BlocProvider(
              create: (_) => ProductFormCubit(
                product: product,
                existingSlugs: existingSlugs,
                defaultCategoryId: defaultCategoryId,
              ),
            ),
          ],
          child: const ProductEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<ProductFormCubit>();
    final isEditing = formCubit.state.isEditing;
    final height = MediaQuery.sizeOf(context).height * 0.82;

    return Dialog(
      child: BlocListener<ProductFormCubit, ProductFormState>(
        listenWhen: (previous, current) =>
            current.status == ProductFormStatus.success,
        listener: (context, state) {
          context.read<ProductsCubit>().save(state.toProduct());
          Navigator.of(context).pop();
        },
        child: SizedBox(
          width: 560,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Edit product' : 'Add product',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _nameField(formCubit),
                        const SizedBox(height: 16),
                        _slugField(formCubit),
                        const SizedBox(height: 16),
                        _descriptionField(formCubit),
                        const SizedBox(height: 16),
                        _categoryField(context),
                        const SizedBox(height: 16),
                        _imageField(),
                        const SizedBox(height: 8),
                        _visibilitySwitch(),
                        if (isEditing) ...[
                          const SizedBox(height: 8),
                          const ProductVariantList(),
                        ],
                      ],
                    ),
                  ),
                ),
                _errorText(theme),
                const SizedBox(height: 16),
                _actions(context, formCubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField(ProductFormCubit formCubit) {
    return TextFormField(
      initialValue: formCubit.state.name,
      textInputAction: TextInputAction.next,
      onChanged: formCubit.nameChanged,
      decoration: const InputDecoration(labelText: 'Name'),
    );
  }

  Widget _slugField(ProductFormCubit formCubit) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      buildWhen: (previous, current) =>
          previous.slug != current.slug && !current.slugLocked,
      builder: (context, state) {
        return TextFormField(
          key: ValueKey(
            state.slugLocked ? 'slug-locked' : 'slug-${state.slug}',
          ),
          initialValue: state.slug,
          textInputAction: TextInputAction.next,
          onChanged: formCubit.slugChanged,
          decoration: const InputDecoration(labelText: 'Slug'),
        );
      },
    );
  }

  Widget _descriptionField(ProductFormCubit formCubit) {
    return TextFormField(
      initialValue: formCubit.state.description,
      minLines: 2,
      maxLines: 4,
      onChanged: formCubit.descriptionChanged,
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  Widget _categoryField(BuildContext context) {
    final categories = context.read<CategoriesCubit>().state.categories;
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      buildWhen: (previous, current) =>
          previous.categoryId != current.categoryId,
      builder: (context, state) {
        if (categories.isEmpty) {
          return Text(
            'Add a category first',
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }
        final value = categories.any((item) => item.id == state.categoryId)
            ? state.categoryId
            : categories.first.id;
        return DropdownButtonFormField<String>(
          key: ValueKey(value),
          initialValue: value,
          decoration: const InputDecoration(labelText: 'Category'),
          items: [
            for (final category in categories)
              DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              ),
          ],
          onChanged: (selected) {
            if (selected == null) return;
            context.read<ProductFormCubit>().categoryChanged(selected);
          },
        );
      },
    );
  }

  Widget _imageField() {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      buildWhen: (previous, current) =>
          previous.imageBytes != current.imageBytes ||
          previous.imageUrl != current.imageUrl,
      builder: (context, state) {
        final cubit = context.read<ProductFormCubit>();
        return ImageUploadField(
          label: 'Product image',
          url: state.imageUrl,
          bytes: state.imageBytes,
          onPicked: cubit.imageChanged,
          onCleared: cubit.imageCleared,
        );
      },
    );
  }

  Widget _visibilitySwitch() {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
      buildWhen: (previous, current) => previous.isVisible != current.isVisible,
      builder: (context, state) {
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Visible on website'),
          value: state.isVisible,
          onChanged: context.read<ProductFormCubit>().visibilityChanged,
        );
      },
    );
  }

  Widget _errorText(ThemeData theme) {
    return BlocBuilder<ProductFormCubit, ProductFormState>(
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

  Widget _actions(BuildContext context, ProductFormCubit formCubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: formCubit.submit, child: const Text('Save')),
      ],
    );
  }
}
