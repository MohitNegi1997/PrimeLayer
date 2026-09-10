import 'package:primelayer_admin_panel/features/inventory/domain/inventory_row.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';

abstract final class InventoryMapper {
  static List<InventoryRow> fromProducts(List<Product> products) {
    return [
      for (final product in products)
        for (final variant in product.variants)
          InventoryRow(
            productId: product.id,
            variantId: variant.id,
            productName: product.name,
            variantName: variant.name,
            sku: variant.sku,
            stock: variant.stock,
            categoryId: product.categoryId,
          ),
    ];
  }
}
