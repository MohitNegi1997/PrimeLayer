import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';

enum ProductVariantFormStatus { initial, success }

class ProductVariantFormState extends Equatable {
  const ProductVariantFormState({
    this.id,
    this.name = '',
    this.sku = '',
    this.price = '',
    this.size = '',
    this.color = '',
    this.material = '',
    this.stock = '0',
    this.existingSkus = const [],
    this.status = ProductVariantFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String sku;
  final String price;
  final String size;
  final String color;
  final String material;
  final String stock;
  final List<String> existingSkus;
  final ProductVariantFormStatus status;
  final String? errorMessage;

  bool get isEditing => id != null;

  ProductVariant toVariant() {
    return ProductVariant(
      id: id ?? 'var-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      sku: sku.trim(),
      price: double.parse(price.trim()),
      size: _optional(size),
      color: _optional(color),
      material: _optional(material),
      stock: int.parse(stock.trim()),
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  ProductVariantFormState copyWith({
    String? id,
    String? name,
    String? sku,
    String? price,
    String? size,
    String? color,
    String? material,
    String? stock,
    List<String>? existingSkus,
    ProductVariantFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductVariantFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      size: size ?? this.size,
      color: color ?? this.color,
      material: material ?? this.material,
      stock: stock ?? this.stock,
      existingSkus: existingSkus ?? this.existingSkus,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
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
    existingSkus,
    status,
    errorMessage,
  ];
}
