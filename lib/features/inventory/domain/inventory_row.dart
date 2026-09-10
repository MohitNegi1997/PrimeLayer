import 'package:equatable/equatable.dart';

class InventoryRow extends Equatable {
  const InventoryRow({
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.variantName,
    required this.sku,
    required this.stock,
    required this.categoryId,
  });

  final String productId;
  final String variantId;
  final String productName;
  final String variantName;
  final String sku;
  final int stock;
  final String categoryId;

  @override
  List<Object?> get props => [
    productId,
    variantId,
    productName,
    variantName,
    sku,
    stock,
    categoryId,
  ];
}
