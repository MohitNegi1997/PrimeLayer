import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/website/data/website_seed.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_content.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';
import 'package:primelayer_admin_panel/features/website/domain/website_section.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/website_state.dart';

class WebsiteCubit extends Cubit<WebsiteState> {
  WebsiteCubit()
    : super(
        const WebsiteState(
          banners: WebsiteSeed.banners,
          faqs: WebsiteSeed.faqs,
          content: WebsiteSeed.content,
        ),
      );

  void sectionChanged(WebsiteSection section) {
    emit(state.copyWith(section: section, clearNotice: true));
  }

  void previewChanged(int index) {
    emit(state.copyWith(previewIndex: index, clearNotice: true));
  }

  void clearNotice() {
    emit(state.copyWith(clearNotice: true));
  }

  void toggleBannerVisibility(String id) {
    emit(
      state.copyWith(
        banners: [
          for (final banner in state.banners)
            if (banner.id == id)
              banner.copyWith(isVisible: !banner.isVisible)
            else
              banner,
        ],
        previewIndex: 0,
        clearNotice: true,
      ),
    );
  }

  void saveBanner(BannerSlide banner) {
    final items = [...state.banners];
    final index = items.indexWhere((item) => item.id == banner.id);
    if (index == -1) {
      items.add(banner.copyWith(sortOrder: items.length));
    } else {
      items[index] = banner.copyWith(sortOrder: items[index].sortOrder);
    }
    emit(state.copyWith(banners: items, notice: '${banner.title} saved'));
  }

  void deleteBanner(String id) {
    emit(
      state.copyWith(
        banners: [
          for (final banner in state.banners)
            if (banner.id != id) banner,
        ],
        previewIndex: 0,
        notice: 'Banner deleted',
      ),
    );
  }

  void saveFaq(SiteFaq faq) {
    final items = [...state.faqs];
    final index = items.indexWhere((item) => item.id == faq.id);
    if (index == -1) {
      items.add(faq);
    } else {
      items[index] = faq;
    }
    emit(state.copyWith(faqs: items, notice: 'FAQ saved'));
  }

  void toggleFaqVisibility(String id) {
    emit(
      state.copyWith(
        faqs: [
          for (final faq in state.faqs)
            if (faq.id == id)
              faq.copyWith(isVisible: !faq.isVisible)
            else
              faq,
        ],
        clearNotice: true,
      ),
    );
  }

  void deleteFaq(String id) {
    emit(
      state.copyWith(
        faqs: [
          for (final faq in state.faqs)
            if (faq.id != id) faq,
        ],
        notice: 'FAQ deleted',
      ),
    );
  }

  void saveContent(SiteContent content) {
    emit(state.copyWith(content: content, notice: 'Site copy saved'));
  }
}
