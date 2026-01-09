import 'package:equatable/equatable.dart';

class HealthQuestionEntity extends Equatable {
  final String id;
  final String question;
  final String description;
  final bool isRequired;
  final bool? answer;

  const HealthQuestionEntity({
    required this.id,
    required this.question,
    required this.description,
    required this.isRequired,
    this.answer,
  });

  HealthQuestionEntity copyWith({
    String? id,
    String? question,
    String? description,
    bool? isRequired,
    bool? answer,
  }) {
    return HealthQuestionEntity(
      id: id ?? this.id,
      question: question ?? this.question,
      description: description ?? this.description,
      isRequired: isRequired ?? this.isRequired,
      answer: answer ?? this.answer,
    );
  }

  @override
  List<Object?> get props => [id, question, description, isRequired, answer];
}
