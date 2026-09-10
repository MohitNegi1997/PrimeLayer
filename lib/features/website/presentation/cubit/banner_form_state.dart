import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';

enum BannerFormStatus { initial, success }

class BannerFormState extends Equatable {
  const BannerFormState({
    this.id,
    this.title = '',
    this.subtitle = '',
    this.ctaLabel = '',
    this.ctaLink = '',
    this.isVisible = true,
    this.imageUrl,
    this.imageBytes,
    this.imageName,
    this.status = BannerFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String ctaLink;
  final bool isVisible;
  final String? imageUrl;
  final List<int>? imageBytes;
  final String? imageName;
  final BannerFormStatus status;
  final String? errorMessage;

  bool get isEditing => id != null;

  BannerSlide toBanner() {
    return BannerSlide(
      id: id ?? 'ban-${DateTime.now().microsecondsSinceEpoch}',
      title: title.trim(),
      subtitle: subtitle.trim(),
      ctaLabel: ctaLabel.trim(),
      ctaLink: ctaLink.trim(),
      isVisible: isVisible,
      sortOrder: 0,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      imageName: imageName,
    );
  }

  BannerFormState copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? ctaLabel,
    String? ctaLink,
    bool? isVisible,
    String? imageUrl,
    List<int>? imageBytes,
    String? imageName,
    BannerFormStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return BannerFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      ctaLabel: ctaLabel ?? this.ctaLabel,
      ctaLink: ctaLink ?? this.ctaLink,
      isVisible: isVisible ?? this.isVisible,
      imageUrl: clearImage ? null : imageUrl ?? this.imageUrl,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageName: clearImage ? null : imageName ?? this.imageName,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
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
    imageUrl,
    imageBytes,
    imageName,
    status,
    errorMessage,
  ];
}
