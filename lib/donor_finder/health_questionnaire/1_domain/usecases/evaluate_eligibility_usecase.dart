import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/eligibility_result_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/repositories/health_questionnaire_repository.dart';

class EvaluateEligibilityUseCase {
  final HealthQuestionnaireRepository repository;

  EvaluateEligibilityUseCase(this.repository);

  EligibilityResultEntity call(List<HealthQuestionEntity> answers) {
    return repository.evaluateEligibility(answers);
  }
}
