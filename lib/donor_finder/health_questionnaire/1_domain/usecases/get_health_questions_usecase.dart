import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/repositories/health_questionnaire_repository.dart';

class GetHealthQuestionsUseCase {
  final HealthQuestionnaireRepository repository;

  GetHealthQuestionsUseCase(this.repository);

  List<HealthQuestionEntity> call() {
    return repository.getHealthQuestions();
  }
}
