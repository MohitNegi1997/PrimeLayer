import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/category_form_state.dart';

class CategoryFormCubit extends Cubit<CategoryFormState> {
  CategoryFormCubit({Category? category, required List<String> existingSlugs})
    : super(
        category == null
            ? CategoryFormState(existingSlugs: existingSlugs)
            : CategoryFormState(
                id: category.id,
                name: category.name,
                slug: category.slug,
                description: category.description,
                iconKey: category.iconKey,
                isVisible: category.isVisible,
                slugLocked: true,
                imageUrl: category.imageUrl,
                imageBytes: category.imageBytes,
                imageName: category.imageName,
                existingSlugs: existingSlugs,
              ),
      );

  static final RegExp _slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

  void nameChanged(String name) {
    emit(
      state.copyWith(
        name: name,
        slug: state.slugLocked ? state.slug : slugify(name),
        status: CategoryFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void slugChanged(String slug) {
    emit(
      state.copyWith(
        slug: slug.toLowerCase(),
        slugLocked: true,
        status: CategoryFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void descriptionChanged(String description) {
    emit(
      state.copyWith(
        description: description,
        status: CategoryFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void iconChanged(String iconKey) {
    emit(
      state.copyWith(
        iconKey: iconKey,
        status: CategoryFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void visibilityChanged(bool isVisible) {
    emit(
      state.copyWith(
        isVisible: isVisible,
        status: CategoryFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void imageChanged(List<int> bytes, String name) {
    emit(
      state.copyWith(
        imageBytes: bytes,
        imageName: name,
        status: CategoryFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void imageCleared() {
    emit(
      state.copyWith(
        clearImage: true,
        status: CategoryFormStatus.initial,
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
    emit(state.copyWith(status: CategoryFormStatus.success, clearError: true));
  }

  static String slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
