import 'package:bloodconnect/donor_finder/health_questionnaire/0_data/datasources/health_questionnaire_datasource.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/0_data/models/health_question_model.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/health_question_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/eligibility_result_entity.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/repositories/health_questionnaire_repository.dart';

class HealthQuestionnaireRepositoryImpl
    implements HealthQuestionnaireRepository {
  final HealthQuestionnaireDataSource dataSource;

  HealthQuestionnaireRepositoryImpl(this.dataSource);

  @override
  List<HealthQuestionEntity> getHealthQuestions() {
    return dataSource.getHealthQuestions();
  }

  @override
  EligibilityResultEntity evaluateEligibility(
      List<HealthQuestionEntity> answers) {
    List<HealthQuestionModel> answerModels = answers
        .map((answer) => HealthQuestionModel.fromEntity(answer))
        .toList();

    return dataSource.evaluateEligibility(answerModels);
  }

  @override
  Future<void> saveEligibilityResult(String userId, bool isEligible) async {
    await dataSource.saveEligibilityResult(userId, isEligible);
  }

  @override
  Future<bool> hasUserCompletedQuestionnaire(String userId) async {
    return await dataSource.hasUserCompletedQuestionnaire(userId);
  }
}
