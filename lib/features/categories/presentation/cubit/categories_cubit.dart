import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/categories/data/categories_seed.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_visibility_filter.dart';
import 'package:primelayer_admin_panel/features/categories/presentation/cubit/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit()
    : super(const CategoriesState(categories: CategoriesSeed.categories));

  void searchChanged(String query) {
    emit(state.copyWith(query: query, clearNotice: true));
  }

  void filterChanged(CategoryVisibilityFilter filter) {
    emit(state.copyWith(filter: filter, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void toggleVisibility(String id) {
    emit(
      state.copyWith(
        categories: [
          for (final category in state.categories)
            if (category.id == id)
              category.copyWith(isVisible: !category.isVisible)
            else
              category,
        ],
        clearNotice: true,
      ),
    );
  }

  void reorder(int oldIndex, int newIndex) {
    if (!state.canReorder) return;
    var target = newIndex;
    if (target > oldIndex) target -= 1;
    final items = [...state.categories];
    final item = items.removeAt(oldIndex);
    items.insert(target, item);
    emit(
      state.copyWith(
        categories: [
          for (var i = 0; i < items.length; i++)
            items[i].copyWith(sortOrder: i),
        ],
        clearNotice: true,
      ),
    );
  }

  void save(Category category) {
    final items = [...state.categories];
    final index = items.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      items.add(category.copyWith(sortOrder: items.length));
    } else {
      items[index] = category.copyWith(sortOrder: items[index].sortOrder);
    }
    emit(state.copyWith(categories: items, notice: '${category.name} saved'));
  }

  void delete(String id, {required int productCount}) {
    final matches = state.categories.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final category = matches.first;
    if (productCount > 0) {
      emit(
        state.copyWith(
          notice: 'Move products out of ${category.name} before deleting it',
        ),
      );
      return;
    }
    final items = [
      for (final item in state.categories)
        if (item.id != id) item,
    ];
    emit(
      state.copyWith(
        categories: [
          for (var i = 0; i < items.length; i++)
            items[i].copyWith(sortOrder: i),
        ],
        notice: '${category.name} deleted',
      ),
    );
  }
}
