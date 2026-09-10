import 'package:equatable/equatable.dart';

class BannerSlide extends Equatable {
  const BannerSlide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.ctaLink,
    required this.isVisible,
    required this.sortOrder,
    this.imageUrl,
    this.imageBytes,
    this.imageName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String ctaLink;
  final bool isVisible;
  final int sortOrder;
  final String? imageUrl;
  final List<int>? imageBytes;
  final String? imageName;

  BannerSlide copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? ctaLabel,
    String? ctaLink,
    bool? isVisible,
    int? sortOrder,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    bool clearImage = false,
  }) {
    return BannerSlide(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      ctaLabel: ctaLabel ?? this.ctaLabel,
      ctaLink: ctaLink ?? this.ctaLink,
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
    title,
    subtitle,
    ctaLabel,
    ctaLink,
    isVisible,
    sortOrder,
    imageUrl,
    imageBytes,
    imageName,
  ];
}
