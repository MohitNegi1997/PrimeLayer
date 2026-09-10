import 'package:equatable/equatable.dart';

class SiteContent extends Equatable {
  const SiteContent({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.about,
    required this.email,
    required this.phone,
    required this.instagram,
    required this.whatsapp,
  });

  final String heroTitle;
  final String heroSubtitle;
  final String about;
  final String email;
  final String phone;
  final String instagram;
  final String whatsapp;

  SiteContent copyWith({
    String? heroTitle,
    String? heroSubtitle,
    String? about,
    String? email,
    String? phone,
    String? instagram,
    String? whatsapp,
  }) {
    return SiteContent(
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      about: about ?? this.about,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      instagram: instagram ?? this.instagram,
      whatsapp: whatsapp ?? this.whatsapp,
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
  ];
}
