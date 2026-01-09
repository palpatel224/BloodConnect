import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/eligibility_result_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/get_health_questions_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/evaluate_eligibility_usecase.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/usecases/save_questionnaire_results_usecase.dart';

part 'health_questionnaire_event.dart';
part 'health_questionnaire_state.dart';

class HealthQuestionnaireBloc
    extends Bloc<HealthQuestionnaireEvent, HealthQuestionnaireState> {
  final GetHealthQuestionsUseCase getHealthQuestionsUseCase;
  final EvaluateEligibilityUseCase evaluateEligibilityUseCase;
  final SaveQuestionnaireResultsUseCase saveQuestionnaireResultsUseCase;

  HealthQuestionnaireBloc({
    required this.getHealthQuestionsUseCase,
    required this.evaluateEligibilityUseCase,
    required this.saveQuestionnaireResultsUseCase,
  }) : super(HealthQuestionnaireInitial()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<SubmitQuestionnaireEvent>(_onSubmitQuestionnaire);
  }

  void _onLoadQuestions(
      LoadQuestionsEvent event, Emitter<HealthQuestionnaireState> emit) {
    try {
      emit(HealthQuestionnaireLoading());

      final questions = getHealthQuestionsUseCase();

      emit(HealthQuestionnaireLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        answers: {},
      ));
    } catch (e) {
      emit(HealthQuestionnaireError(message: e.toString()));
    }
  }

  void _onAnswerQuestion(
      AnswerQuestionEvent event, Emitter<HealthQuestionnaireState> emit) {
    if (state is HealthQuestionnaireLoaded) {
      final currentState = state as HealthQuestionnaireLoaded;
      final updatedAnswers = Map<String, bool>.from(currentState.answers);
      updatedAnswers[event.questionId] = event.answer;

      emit(currentState.copyWith(answers: updatedAnswers));
    }
  }

  void _onNextQuestion(
      NextQuestionEvent event, Emitter<HealthQuestionnaireState> emit) {
    if (state is HealthQuestionnaireLoaded) {
      final currentState = state as HealthQuestionnaireLoaded;

      if (!currentState.isLastQuestion && currentState.canProceed) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
        ));
      }
    }
  }

  void _onPreviousQuestion(
      PreviousQuestionEvent event, Emitter<HealthQuestionnaireState> emit) {
    if (state is HealthQuestionnaireLoaded) {
      final currentState = state as HealthQuestionnaireLoaded;

      if (currentState.currentQuestionIndex > 0) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex - 1,
        ));
      }
    }
  }

  void _onSubmitQuestionnaire(SubmitQuestionnaireEvent event,
      Emitter<HealthQuestionnaireState> emit) async {
    if (state is HealthQuestionnaireLoaded) {
      final currentState = state as HealthQuestionnaireLoaded;

      if (!currentState.allQuestionsAnswered) {
        emit(const HealthQuestionnaireError(
            message: 'Please answer all questions'));
        return;
      }

      try {
        emit(HealthQuestionnaireLoading());

        // Create answered questions list
        final answeredQuestions = currentState.questions.map((question) {
          return question.copyWith(answer: currentState.answers[question.id]);
        }).toList();

        // Evaluate eligibility
        final result = evaluateEligibilityUseCase(answeredQuestions);

        // Save only the eligibility result
        await saveQuestionnaireResultsUseCase(event.userId, result.isEligible);

        emit(HealthQuestionnaireCompleted(result: result));
      } catch (e) {
        emit(HealthQuestionnaireError(message: e.toString()));
      }
    }
  }
}
