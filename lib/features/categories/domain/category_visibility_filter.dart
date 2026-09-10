enum CategoryVisibilityFilter {
  all,
  visible,
  hidden;

  String get label => switch (this) {
    CategoryVisibilityFilter.all => 'All',
    CategoryVisibilityFilter.visible => 'Visible',
    CategoryVisibilityFilter.hidden => 'Hidden',
  };
}
