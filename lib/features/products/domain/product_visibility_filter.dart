enum ProductVisibilityFilter {
  all,
  visible,
  hidden;

  String get label => switch (this) {
    ProductVisibilityFilter.all => 'All',
    ProductVisibilityFilter.visible => 'Visible',
    ProductVisibilityFilter.hidden => 'Hidden',
  };
}
