import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/eligibility_result_entity.dart';

abstract class HealthQuestionnaireRepository {
  List<HealthQuestionEntity> getHealthQuestions();
  EligibilityResultEntity evaluateEligibility(
      List<HealthQuestionEntity> answers);
  Future<void> saveEligibilityResult(String userId, bool isEligible);
  Future<bool> hasUserCompletedQuestionnaire(String userId);
}
