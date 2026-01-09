import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/repositories/health_questionnaire_repository.dart';

class SaveQuestionnaireResultsUseCase {
  final HealthQuestionnaireRepository repository;

  SaveQuestionnaireResultsUseCase(this.repository);

  Future<void> call(String userId, bool isEligible) async {
    return await repository.saveEligibilityResult(userId, isEligible);
  }
}
