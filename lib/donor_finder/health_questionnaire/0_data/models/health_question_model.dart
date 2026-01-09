import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';

class HealthQuestionModel extends HealthQuestionEntity {
  const HealthQuestionModel({
    required super.id,
    required super.question,
    required super.description,
    required super.isRequired,
    super.answer,
  });

  factory HealthQuestionModel.fromEntity(HealthQuestionEntity entity) {
    return HealthQuestionModel(
      id: entity.id,
      question: entity.question,
      description: entity.description,
      isRequired: entity.isRequired,
      answer: entity.answer,
    );
  }
}
