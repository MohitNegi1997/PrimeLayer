import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_visibility_filter.dart';

class ProductsState extends Equatable {
  const ProductsState({
    required this.products,
    this.query = '',
    this.categoryId,
    this.filter = ProductVisibilityFilter.all,
    this.page = 0,
    this.notice,
  });

  final List<Product> products;
  final String query;
  final String? categoryId;
  final ProductVisibilityFilter filter;
  final int page;
  final String? notice;

  List<Product> get filteredProducts {
    final needle = query.trim().toLowerCase();
    return [
      for (final product in products)
        if (_matches(product, needle)) product,
    ];
  }

  int get safePage => PageSlice.clampPage(page, filteredProducts.length);

  List<Product> get pagedProducts =>
      PageSlice.of(filteredProducts, safePage);

  int countInCategory(String id) {
    var count = 0;
    for (final product in products) {
      if (product.categoryId == id) count += 1;
    }
    return count;
  }

  List<Product> productsInCategory(String id) {
    return [
      for (final product in products)
        if (product.categoryId == id) product,
    ];
  }

  Product? byId(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  ProductVariant? variantById(String id) {
    for (final product in products) {
      for (final variant in product.variants) {
        if (variant.id == id) return variant;
      }
    }
    return null;
  }

  bool _matches(Product product, String needle) {
    final matchesFilter = switch (filter) {
      ProductVisibilityFilter.all => true,
      ProductVisibilityFilter.visible => product.isVisible,
      ProductVisibilityFilter.hidden => !product.isVisible,
    };
    if (!matchesFilter) return false;
    if (categoryId != null && product.categoryId != categoryId) return false;
    if (needle.isEmpty) return true;
    return product.name.toLowerCase().contains(needle) ||
        product.slug.contains(needle);
  }

  ProductsState copyWith({
    List<Product>? products,
    String? query,
    String? categoryId,
    ProductVisibilityFilter? filter,
    int? page,
    String? notice,
    bool clearCategoryId = false,
    bool clearNotice = false,
  }) {
    return ProductsState(
      products: products ?? this.products,
      query: query ?? this.query,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      filter: filter ?? this.filter,
      page: page ?? this.page,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [
    products,
    query,
    categoryId,
    filter,
    page,
    notice,
  ];
}
