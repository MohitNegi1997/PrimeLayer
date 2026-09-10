import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_content.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/site_content_form_state.dart';

class SiteContentFormCubit extends Cubit<SiteContentFormState> {
  SiteContentFormCubit(SiteContent content)
    : super(SiteContentFormState.fromContent(content));

  void heroTitleChanged(String value) {
    emit(state.copyWith(heroTitle: value, status: SiteContentFormStatus.initial));
  }

  void heroSubtitleChanged(String value) {
    emit(
      state.copyWith(heroSubtitle: value, status: SiteContentFormStatus.initial),
    );
  }

  void aboutChanged(String value) {
    emit(state.copyWith(about: value, status: SiteContentFormStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SiteContentFormStatus.initial));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: SiteContentFormStatus.initial));
  }

  void instagramChanged(String value) {
    emit(
      state.copyWith(instagram: value, status: SiteContentFormStatus.initial),
    );
  }

  void whatsappChanged(String value) {
    emit(state.copyWith(whatsapp: value, status: SiteContentFormStatus.initial));
  }

  void submit() {
    if (state.heroTitle.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a hero title'));
      return;
    }
    emit(
      state.copyWith(
        status: SiteContentFormStatus.success,
        clearError: true,
      ),
    );
  }
}
