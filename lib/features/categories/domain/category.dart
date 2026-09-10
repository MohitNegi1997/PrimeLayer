import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.iconKey,
    required this.isVisible,
    required this.sortOrder,
    required this.productIds,
  });

  final String id;
  final String name;
  final String slug;
  final String description;
  final String iconKey;
  final bool isVisible;
  final int sortOrder;
  final List<String> productIds;

  int get productCount => productIds.length;

  Category copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? iconKey,
    bool? isVisible,
    int? sortOrder,
    List<String>? productIds,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      isVisible: isVisible ?? this.isVisible,
      sortOrder: sortOrder ?? this.sortOrder,
      productIds: productIds ?? this.productIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    iconKey,
    isVisible,
    sortOrder,
    productIds,
  ];
}
