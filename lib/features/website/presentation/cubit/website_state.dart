import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_content.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';
import 'package:primelayer_admin_panel/features/website/domain/website_section.dart';

class WebsiteState extends Equatable {
  const WebsiteState({
    required this.banners,
    required this.faqs,
    required this.content,
    this.section = WebsiteSection.banners,
    this.previewIndex = 0,
    this.notice,
  });

  final List<BannerSlide> banners;
  final List<SiteFaq> faqs;
  final SiteContent content;
  final WebsiteSection section;
  final int previewIndex;
  final String? notice;

  List<BannerSlide> get visibleBanners => [
    for (final banner in banners)
      if (banner.isVisible) banner,
  ];

  BannerSlide? get previewBanner {
    if (visibleBanners.isEmpty) return null;
    final index = previewIndex.clamp(0, visibleBanners.length - 1);
    return visibleBanners[index];
  }

  WebsiteState copyWith({
    List<BannerSlide>? banners,
    List<SiteFaq>? faqs,
    SiteContent? content,
    WebsiteSection? section,
    int? previewIndex,
    String? notice,
    bool clearNotice = false,
  }) {
    return WebsiteState(
      banners: banners ?? this.banners,
      faqs: faqs ?? this.faqs,
      content: content ?? this.content,
      section: section ?? this.section,
      previewIndex: previewIndex ?? this.previewIndex,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [
    banners,
    faqs,
    content,
    section,
    previewIndex,
    notice,
  ];
}
