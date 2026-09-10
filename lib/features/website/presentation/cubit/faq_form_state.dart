import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/features/website/domain/site_faq.dart';

enum FaqFormStatus { initial, success }

class FaqFormState extends Equatable {
  const FaqFormState({
    this.id,
    this.question = '',
    this.answer = '',
    this.isVisible = true,
    this.status = FaqFormStatus.initial,
    this.errorMessage,
  });

  final String? id;
  final String question;
  final String answer;
  final bool isVisible;
  final FaqFormStatus status;
  final String? errorMessage;

  SiteFaq toFaq() {
    return SiteFaq(
      id: id ?? 'faq-${DateTime.now().microsecondsSinceEpoch}',
      question: question.trim(),
      answer: answer.trim(),
      isVisible: isVisible,
    );
  }

  FaqFormState copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isVisible,
    FaqFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FaqFormState(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isVisible: isVisible ?? this.isVisible,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [id, question, answer, isVisible, status, errorMessage];
}
