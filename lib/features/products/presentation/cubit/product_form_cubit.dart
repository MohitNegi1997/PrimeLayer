import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';
import 'package:primelayer_admin_panel/features/products/presentation/cubit/product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    Product? product,
    required List<String> existingSlugs,
    required String defaultCategoryId,
  }) : super(
         product == null
             ? ProductFormState(
                 categoryId: defaultCategoryId,
                 existingSlugs: existingSlugs,
               )
             : ProductFormState(
                 id: product.id,
                 name: product.name,
                 slug: product.slug,
                 description: product.description,
                 categoryId: product.categoryId,
                 isVisible: product.isVisible,
                 slugLocked: true,
                 variants: product.variants,
                 imageUrl: product.imageUrl,
                 imageBytes: product.imageBytes,
                 imageName: product.imageName,
                 existingSlugs: existingSlugs,
               ),
       );

  static final RegExp _slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
        slug: state.slugLocked ? state.slug : slugify(name),
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void slugChanged(String slug) {
    emit(
      state.copyWith(
        slug: slug.toLowerCase(),
        slugLocked: true,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void descriptionChanged(String description) {
    emit(
      state.copyWith(
        description: description,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void categoryChanged(String categoryId) {
    emit(
      state.copyWith(
        categoryId: categoryId,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void visibilityChanged(bool isVisible) {
    emit(
      state.copyWith(
        isVisible: isVisible,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void imageChanged(List<int> bytes, String name) {
    emit(
      state.copyWith(
        imageBytes: bytes,
        imageName: name,
        imageUrl: null,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void imageCleared() {
    emit(
      state.copyWith(
        clearImage: true,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void saveVariant(ProductVariant variant) {
    final items = [...state.variants];
    final index = items.indexWhere((item) => item.id == variant.id);
    if (index == -1) {
      items.add(variant);
    } else {
      items[index] = variant;
    }
    emit(
      state.copyWith(
        variants: items,
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void deleteVariant(String id) {
    emit(
      state.copyWith(
        variants: [
          for (final variant in state.variants)
            if (variant.id != id) variant,
        ],
        status: ProductFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    final name = state.name.trim();
    final slug = state.slug.trim();
    if (name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a name'));
      return;
    }
    if (slug.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a slug'));
      return;
    }
    if (!_slugPattern.hasMatch(slug)) {
      emit(
        state.copyWith(
          errorMessage: 'Use lowercase letters, numbers, and hyphens',
        ),
      );
      return;
    }
    if (state.existingSlugs.contains(slug)) {
      emit(state.copyWith(errorMessage: 'Slug already in use'));
      return;
    }
    if (state.categoryId.isEmpty) {
      emit(state.copyWith(errorMessage: 'Select a category'));
      return;
    }
    emit(state.copyWith(status: ProductFormStatus.success, clearError: true));
  }

  static String slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
