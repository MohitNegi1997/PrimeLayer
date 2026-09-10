import 'package:equatable/equatable.dart';

class SiteFaq extends Equatable {
  const SiteFaq({
    required this.id,
    required this.question,
    required this.answer,
    required this.isVisible,
  });

  final String id;
  final String question;
  final String answer;
  final bool isVisible;

  SiteFaq copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isVisible,
  }) {
    return SiteFaq(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [id, question, answer, isVisible];
}
