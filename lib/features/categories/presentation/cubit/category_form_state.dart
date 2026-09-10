import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category.dart';
import 'package:primelayer_admin_panel/features/categories/domain/category_icons.dart';

enum CategoryFormStatus { initial, success }

class CategoryFormState extends Equatable {
  const CategoryFormState({
    this.id,
    this.name = '',
    this.slug = '',
    this.description = '',
    this.iconKey = CategoryIcons.category,
    this.isVisible = true,
    this.slugLocked = false,
    this.imageUrl,
    this.imageBytes,
    this.imageName,
    this.existingSlugs = const [],
    this.status = CategoryFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String name;
  final String slug;
  final String description;
  final String iconKey;
  final bool isVisible;
  final bool slugLocked;
  final String? imageUrl;
  final List<int>? imageBytes;
  final String? imageName;
  final List<String> existingSlugs;
  final CategoryFormStatus status;
  final String? errorMessage;

  bool get isEditing => id != null;

  Category toCategory() {
    return Category(
      id: id ?? 'cat-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      slug: slug.trim(),
      description: description.trim(),
      iconKey: iconKey,
      isVisible: isVisible,
      sortOrder: 0,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imageName: imageName,
    );
  }

  CategoryFormState copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? iconKey,
    bool? isVisible,
    bool? slugLocked,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    List<String>? existingSlugs,
    CategoryFormStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return CategoryFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      isVisible: isVisible ?? this.isVisible,
      slugLocked: slugLocked ?? this.slugLocked,
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
    iconKey,
    isVisible,
    slugLocked,
    imageUrl,
    imageBytes,
    imageName,
    existingSlugs,
    status,
    errorMessage,
  ];
}
