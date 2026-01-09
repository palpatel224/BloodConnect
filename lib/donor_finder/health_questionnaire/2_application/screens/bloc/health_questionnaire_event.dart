part of 'health_questionnaire_bloc.dart';

abstract class HealthQuestionnaireEvent extends Equatable {
  const HealthQuestionnaireEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionsEvent extends HealthQuestionnaireEvent {}

class AnswerQuestionEvent extends HealthQuestionnaireEvent {
  final String questionId;
  final bool answer;

  const AnswerQuestionEvent({
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object> get props => [questionId, answer];
}

class SubmitQuestionnaireEvent extends HealthQuestionnaireEvent {
  final String userId;

  const SubmitQuestionnaireEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class NextQuestionEvent extends HealthQuestionnaireEvent {}

class PreviousQuestionEvent extends HealthQuestionnaireEvent {}
