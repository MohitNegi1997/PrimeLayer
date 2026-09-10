import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/features/inventory/domain/inventory_row.dart';

class InventoryState extends Equatable {
  const InventoryState({
    this.query = '',
    this.lowStockOnly = false,
    this.page = 0,
  });

  final String query;
  final bool lowStockOnly;
  final int page;

  List<InventoryRow> filtered(
    List<InventoryRow> rows, {
    required int threshold,
  }) {
    final needle = query.trim().toLowerCase();
    return [
      for (final row in rows)
        if (_matches(row, needle, threshold)) row,
    ];
  }

  List<InventoryRow> paged(List<InventoryRow> rows, {required int threshold}) {
    final items = filtered(rows, threshold: threshold);
    return PageSlice.of(items, PageSlice.clampPage(page, items.length));
  }

  bool _matches(InventoryRow row, String needle, int threshold) {
    if (lowStockOnly && row.stock > threshold) return false;
    if (needle.isEmpty) return true;
    return row.productName.toLowerCase().contains(needle) ||
        row.sku.toLowerCase().contains(needle) ||
        row.variantName.toLowerCase().contains(needle);
  }

  InventoryState copyWith({
    String? query,
    bool? lowStockOnly,
    int? page,
  }) {
    return InventoryState(
      query: query ?? this.query,
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [query, lowStockOnly, page];
}
