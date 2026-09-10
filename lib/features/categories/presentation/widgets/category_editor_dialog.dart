import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/image_upload_field.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/category_form_cubit.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/category_form_state.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_cubit.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/products_state.dart';

class CategoryEditorDialog extends StatelessWidget {
  const CategoryEditorDialog({super.key});

  static Future<void> open(BuildContext context, {Category? category}) {
    final cubit = context.read<CategoriesCubit>();
    final existingSlugs = [
      for (final item in cubit.state.categories)
        if (item.id != category?.id) item.slug,
    ];

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider.value(value: context.read<ProductsCubit>()),
            BlocProvider(
              create: (_) => CategoryFormCubit(
                category: category,
                existingSlugs: existingSlugs,
              ),
            ),
          ],
          child: const CategoryEditorDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formCubit = context.read<CategoryFormCubit>();
    final isEditing = formCubit.state.isEditing;
    final height = MediaQuery.sizeOf(context).height * 0.82;

    return Dialog(
      child: BlocListener<CategoryFormCubit, CategoryFormState>(
        listenWhen: (previous, current) =>
            current.status == CategoryFormStatus.success,
        listener: (context, state) {
          context.read<CategoriesCubit>().save(state.toCategory());
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
                  isEditing ? 'Edit category' : 'Add category',
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
                        Text('Icon', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        _iconPicker(),
                        const SizedBox(height: 16),
                        _imageField(),
                        const SizedBox(height: 8),
                        _visibilitySwitch(),
                        const SizedBox(height: 8),
                        Text('Products', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        _assignedProducts(),
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

  Widget _nameField(CategoryFormCubit formCubit) {
    return TextFormField(
      initialValue: formCubit.state.name,
      textInputAction: TextInputAction.next,
      onChanged: formCubit.nameChanged,
      decoration: const InputDecoration(labelText: 'Name'),
    );
  }

  Widget _slugField(CategoryFormCubit formCubit) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
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

  Widget _descriptionField(CategoryFormCubit formCubit) {
    return TextFormField(
      initialValue: formCubit.state.description,
      minLines: 2,
      maxLines: 4,
      onChanged: formCubit.descriptionChanged,
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  Widget _iconPicker() {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      buildWhen: (previous, current) => previous.iconKey != current.iconKey,
      builder: (context, state) {
        return CategoryIconPicker(
          selectedKey: state.iconKey,
          onChanged: context.read<CategoryFormCubit>().iconChanged,
        );
      },
    );
  }

  Widget _imageField() {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      buildWhen: (previous, current) =>
          previous.imageBytes != current.imageBytes ||
          previous.imageUrl != current.imageUrl,
      builder: (context, state) {
        final cubit = context.read<CategoryFormCubit>();
        return ImageUploadField(
          label: 'Category image',
          url: state.imageUrl,
          bytes: state.imageBytes,
          onPicked: cubit.imageChanged,
          onCleared: cubit.imageCleared,
        );
      },
    );
  }

  Widget _visibilitySwitch() {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
      buildWhen: (previous, current) => previous.isVisible != current.isVisible,
      builder: (context, state) {
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Visible on website'),
          value: state.isVisible,
          onChanged: context.read<CategoryFormCubit>().visibilityChanged,
        );
      },
    );
  }

  Widget _assignedProducts() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final categoryId = context.read<CategoryFormCubit>().state.id;
        if (categoryId == null) {
          return Text(
            'Save this category, then assign products from Product Management',
            style: theme.textTheme.bodyMedium,
          );
        }
        final products = state.productsInCategory(categoryId);
        if (products.isEmpty) {
          return Text(
            'No products in this category',
            style: theme.textTheme.bodyMedium,
          );
        }
        return Column(
          children: [
            for (final product in products)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(product.name),
                subtitle: Text(product.variantLabel),
              ),
          ],
        );
      },
    );
  }

  Widget _errorText(ThemeData theme) {
    return BlocBuilder<CategoryFormCubit, CategoryFormState>(
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

  Widget _actions(BuildContext context, CategoryFormCubit formCubit) {
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
