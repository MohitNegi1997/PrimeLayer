import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_content.dart';

enum SiteContentFormStatus { initial, success }

class SiteContentFormState extends Equatable {
  const SiteContentFormState({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.about,
    required this.email,
    required this.phone,
    required this.instagram,
    required this.whatsapp,
    this.status = SiteContentFormStatus.initial,
    this.errorMessage,
  });

  final String heroTitle;
  final String heroSubtitle;
  final String about;
  final String email;
  final String phone;
  final String instagram;
  final String whatsapp;
  final SiteContentFormStatus status;
  final String? errorMessage;

  factory SiteContentFormState.fromContent(SiteContent content) {
    return SiteContentFormState(
      heroTitle: content.heroTitle,
      heroSubtitle: content.heroSubtitle,
      about: content.about,
      email: content.email,
      phone: content.phone,
      instagram: content.instagram,
      whatsapp: content.whatsapp,
    );
  }

  SiteContent toContent() {
    return SiteContent(
      heroTitle: heroTitle.trim(),
      heroSubtitle: heroSubtitle.trim(),
      about: about.trim(),
      email: email.trim(),
      phone: phone.trim(),
      instagram: instagram.trim(),
      whatsapp: whatsapp.trim(),
    );
  }

  SiteContentFormState copyWith({
    String? heroTitle,
    String? heroSubtitle,
    String? about,
    String? email,
    String? phone,
    String? instagram,
    String? whatsapp,
    SiteContentFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SiteContentFormState(
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      about: about ?? this.about,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      instagram: instagram ?? this.instagram,
      whatsapp: whatsapp ?? this.whatsapp,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    heroTitle,
    heroSubtitle,
    about,
    email,
    phone,
    instagram,
    whatsapp,
    status,
    errorMessage,
  ];
}
