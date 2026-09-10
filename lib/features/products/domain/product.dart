import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.categoryId,
    required this.isVisible,
    required this.variants,
    this.imageUrl,
    this.imageBytes,
    this.imageName,
  });

  final String id;
  final String name;
  final String slug;
  final String description;
  final String categoryId;
  final bool isVisible;
  final List<ProductVariant> variants;
  final String? imageUrl;
  final List<int>? imageBytes;
  final String? imageName;

  int get variantCount => variants.length;

  String get variantLabel =>
      variantCount == 1 ? '1 variant' : '$variantCount variants';

  int get totalStock {
    var sum = 0;
    for (final variant in variants) {
      sum += variant.stock;
    }
    return sum;
  }

  String get priceLabel {
    if (variants.isEmpty) return 'No variants';
    final prices = [for (final variant in variants) variant.price]..sort();
    final low = '₹${prices.first.toStringAsFixed(0)}';
    if (prices.first == prices.last) return low;
    return '$low – ₹${prices.last.toStringAsFixed(0)}';
  }

  Product copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? categoryId,
    bool? isVisible,
    List<ProductVariant>? variants,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    bool clearImage = false,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isVisible: isVisible ?? this.isVisible,
      variants: variants ?? this.variants,
      imageUrl: clearImage ? null : imageUrl ?? this.imageUrl,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageName: clearImage ? null : imageName ?? this.imageName,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    categoryId,
    isVisible,
    variants,
    imageUrl,
    imageBytes,
    imageName,
  ];
}
