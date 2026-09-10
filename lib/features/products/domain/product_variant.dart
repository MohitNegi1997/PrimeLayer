import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  const ProductVariant({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    this.size,
    this.color,
    this.material,
    this.stock = 0,
  });

  final String id;
  final String name;
  final String sku;
  final double price;
  final String? size;
  final String? color;
  final String? material;
  final int stock;

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';

  ProductVariant copyWith({
    String? id,
    String? name,
    String? sku,
    double? price,
    String? size,
    String? color,
    String? material,
    int? stock,
    bool clearSize = false,
    bool clearColor = false,
    bool clearMaterial = false,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      size: clearSize ? null : size ?? this.size,
      color: clearColor ? null : color ?? this.color,
      material: clearMaterial ? null : material ?? this.material,
      stock: stock ?? this.stock,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    sku,
    price,
    size,
    color,
    material,
    stock,
  ];
}
