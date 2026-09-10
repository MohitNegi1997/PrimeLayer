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
    this.imageUrl,
    this.imageBytes,
    this.imageName,
  });

  final String id;
  final String name;
  final String slug;
  final String description;
  final String iconKey;
  final bool isVisible;
  final int sortOrder;
  final String? imageUrl;
  final List<int>? imageBytes;
  final String? imageName;

  Category copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? iconKey,
    bool? isVisible,
    int? sortOrder,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    bool clearImage = false,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      isVisible: isVisible ?? this.isVisible,
      sortOrder: sortOrder ?? this.sortOrder,
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
    iconKey,
    isVisible,
    sortOrder,
    imageUrl,
    imageBytes,
    imageName,
  ];
}
