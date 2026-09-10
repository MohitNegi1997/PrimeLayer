import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/website/domain/banner_slide.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/banner_form_state.dart';

class BannerFormCubit extends Cubit<BannerFormState> {
  BannerFormCubit({BannerSlide? banner})
    : super(
        banner == null
            ? const BannerFormState()
            : BannerFormState(
                id: banner.id,
                title: banner.title,
                subtitle: banner.subtitle,
                ctaLabel: banner.ctaLabel,
                ctaLink: banner.ctaLink,
                isVisible: banner.isVisible,
                imageUrl: banner.imageUrl,
                imageBytes: banner.imageBytes,
                imageName: banner.imageName,
              ),
      );

  void titleChanged(String title) {
    emit(
      state.copyWith(
        title: title,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void subtitleChanged(String subtitle) {
    emit(
      state.copyWith(
        subtitle: subtitle,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void ctaLabelChanged(String ctaLabel) {
    emit(
      state.copyWith(
        ctaLabel: ctaLabel,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void ctaLinkChanged(String ctaLink) {
    emit(
      state.copyWith(
        ctaLink: ctaLink,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void visibilityChanged(bool isVisible) {
    emit(
      state.copyWith(
        isVisible: isVisible,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void imageChanged(List<int> bytes, String name) {
    emit(
      state.copyWith(
        imageBytes: bytes,
        imageName: name,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void imageCleared() {
    emit(
      state.copyWith(
        clearImage: true,
        status: BannerFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a title'));
      return;
    }
    emit(state.copyWith(status: BannerFormStatus.success, clearError: true));
  }
}
