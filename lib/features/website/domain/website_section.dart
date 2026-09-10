enum WebsiteSection {
  banners,
  faqs,
  content;

  String get label => switch (this) {
    WebsiteSection.banners => 'Banners',
    WebsiteSection.faqs => 'FAQs',
    WebsiteSection.content => 'Site copy',
  };
}
