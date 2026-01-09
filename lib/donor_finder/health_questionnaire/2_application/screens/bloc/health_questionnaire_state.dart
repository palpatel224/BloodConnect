part of 'health_questionnaire_bloc.dart';

abstract class HealthQuestionnaireState extends Equatable {
  const HealthQuestionnaireState();

  @override
  List<Object?> get props => [];
}

class HealthQuestionnaireInitial extends HealthQuestionnaireState {}

class HealthQuestionnaireLoading extends HealthQuestionnaireState {}

class HealthQuestionnaireLoaded extends HealthQuestionnaireState {
  final List<HealthQuestionEntity> questions;
  final int currentQuestionIndex;
  final Map<String, bool> answers;

  const HealthQuestionnaireLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.answers,
  });

  @override
  List<Object?> get props => [questions, currentQuestionIndex, answers];

  HealthQuestionnaireLoaded copyWith({
    List<HealthQuestionEntity>? questions,
    int? currentQuestionIndex,
    Map<String, bool>? answers,
  }) {
    return HealthQuestionnaireLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
    );
  }

  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;
  bool get canProceed =>
      answers.containsKey(questions[currentQuestionIndex].id);
  bool get allQuestionsAnswered => answers.length == questions.length;
}

class HealthQuestionnaireCompleted extends HealthQuestionnaireState {
  final EligibilityResultEntity result;

  const HealthQuestionnaireCompleted({required this.result});

  @override
  List<Object?> get props => [result];
}

class HealthQuestionnaireError extends HealthQuestionnaireState {
  final String message;

  const HealthQuestionnaireError({required this.message});

  @override
  List<Object> get props => [message];
}
