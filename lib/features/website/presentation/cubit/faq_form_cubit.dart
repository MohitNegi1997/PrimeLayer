import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';
import 'package:primelayer_admin_panel/features/website/presentation/cubit/faq_form_state.dart';

class FaqFormCubit extends Cubit<FaqFormState> {
  FaqFormCubit({SiteFaq? faq})
    : super(
        faq == null
            ? const FaqFormState()
            : FaqFormState(
                id: faq.id,
                question: faq.question,
                answer: faq.answer,
                isVisible: faq.isVisible,
              ),
      );

  void questionChanged(String question) {
    emit(
      state.copyWith(
        question: question,
        status: FaqFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void answerChanged(String answer) {
    emit(
      state.copyWith(
        answer: answer,
        status: FaqFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void visibilityChanged(bool isVisible) {
    emit(
      state.copyWith(
        isVisible: isVisible,
        status: FaqFormStatus.initial,
        clearError: true,
      ),
    );
  }

  void submit() {
    if (state.question.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a question'));
      return;
    }
    if (state.answer.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter an answer'));
      return;
    }
    emit(state.copyWith(status: FaqFormStatus.success, clearError: true));
  }
}
