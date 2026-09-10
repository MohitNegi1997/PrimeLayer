import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_content.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';

abstract final class WebsiteSeed {
  static const List<BannerSlide> banners = [
    BannerSlide(
      id: 'ban-01',
      title: 'Print your world',
      subtitle: 'Custom figurines, desk tools, and home prints from Prime Layer Studio.',
      ctaLabel: 'Shop figurines',
      ctaLink: '/shop/figurines',
      isVisible: true,
      sortOrder: 0,
    ),
    BannerSlide(
      id: 'ban-02',
      title: 'New dragon drop',
      subtitle: '15cm and 20cm PLA dragons, ready to ship this week.',
      ctaLabel: 'View dragon',
      ctaLink: '/shop/dragon',
      isVisible: true,
      sortOrder: 1,
    ),
    BannerSlide(
      id: 'ban-03',
      title: 'Studio pickup',
      subtitle: 'Skip shipping. Collect from the studio the same day your print finishes.',
      ctaLabel: 'See shipping',
      ctaLink: '/shipping',
      isVisible: true,
      sortOrder: 2,
    ),
  ];

  static const List<SiteFaq> faqs = [
    SiteFaq(
      id: 'faq-01',
      question: 'How long does printing take?',
      answer: 'Most orders enter the print queue within a day and ship in 5–7 days.',
      isVisible: true,
    ),
    SiteFaq(
      id: 'faq-02',
      question: 'Can I request a custom color?',
      answer: 'Yes. Add a note at checkout and we will confirm filament options.',
      isVisible: true,
    ),
    SiteFaq(
      id: 'faq-03',
      question: 'Do you offer studio pickup?',
      answer: 'Pickup is free in Jaipur once the print is packed.',
      isVisible: true,
    ),
  ];

  static const SiteContent content = SiteContent(
    heroTitle: 'Prime Layer Studio',
    heroSubtitle: '3D printed goods designed and packed in-house.',
    about:
        'We design, print, and finish small-batch products. Categories and banners you set here appear on the storefront.',
    email: 'hello@primelayer.studio',
    phone: '9876500999',
    instagram: '@primelayer.studio',
    whatsapp: '9876500999',
  );
}
