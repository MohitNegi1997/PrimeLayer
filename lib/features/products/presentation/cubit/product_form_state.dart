import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/products/domain/product.dart';
import 'package:primelayer_admin_panel/features/products/domain/product_variant.dart';

enum ProductFormStatus { initial, success }

class ProductFormState extends Equatable {
  const ProductFormState({
    this.id,
    this.name = '',
    this.slug = '',
    this.description = '',
    this.categoryId = '',
    this.isVisible = true,
    this.slugLocked = false,
    this.variants = const [],
    this.imageUrl,
    this.imageBytes,
    this.imageName,
    this.existingSlugs = const [],
    this.status = ProductFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String slug;
  final String description;
  final String categoryId;
  final bool isVisible;
  final bool slugLocked;
  final List<ProductVariant> variants;
  final String? imageUrl;
  final List<int>? imageBytes;
  final String? imageName;
  final List<String> existingSlugs;
  final ProductFormStatus status;
  final String? errorMessage;

  bool get isEditing => id != null;

  Product toProduct() {
    return Product(
      id: id ?? 'prod-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      slug: slug.trim(),
      description: description.trim(),
      categoryId: categoryId,
      isVisible: isVisible,
      variants: variants,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imageName: imageName,
    );
  }

  ProductFormState copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? categoryId,
    bool? isVisible,
    bool? slugLocked,
    List<ProductVariant>? variants,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    List<String>? existingSlugs,
    ProductFormStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return ProductFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isVisible: isVisible ?? this.isVisible,
      slugLocked: slugLocked ?? this.slugLocked,
      variants: variants ?? this.variants,
      imageUrl: clearImage ? null : imageUrl ?? this.imageUrl,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageName: clearImage ? null : imageName ?? this.imageName,
      existingSlugs: existingSlugs ?? this.existingSlugs,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
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
    slugLocked,
    variants,
    imageUrl,
    imageBytes,
    imageName,
    existingSlugs,
    status,
    errorMessage,
  ];
}
