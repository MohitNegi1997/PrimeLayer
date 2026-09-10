import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_visibility_filter.dart';

class CategoriesState extends Equatable {
  const CategoriesState({
    required this.categories,
    this.query = '',
    this.filter = CategoryVisibilityFilter.all,
    this.notice,
  });

  final List<Category> categories;
  final String query;
  final CategoryVisibilityFilter filter;
  final String? notice;

  bool get canReorder =>
      query.trim().isEmpty && filter == CategoryVisibilityFilter.all;

  List<Category> get filteredCategories {
    final needle = query.trim().toLowerCase();
    return [
      for (final category in categories)
        if (_matches(category, needle)) category,
    ];
  }

  bool _matches(Category category, String needle) {
    final matchesFilter = switch (filter) {
      CategoryVisibilityFilter.all => true,
      CategoryVisibilityFilter.visible => category.isVisible,
      CategoryVisibilityFilter.hidden => !category.isVisible,
    };
    if (!matchesFilter) return false;
    if (needle.isEmpty) return true;
    return category.name.toLowerCase().contains(needle) ||
        category.slug.contains(needle);
  }

  CategoriesState copyWith({
    List<Category>? categories,
    String? query,
    CategoryVisibilityFilter? filter,
    String? notice,
    bool clearNotice = false,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [categories, query, filter, notice];
}
