import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/repositories/health_questionnaire_repository.dart';

class CheckQuestionnaireCompletionUseCase {
  final HealthQuestionnaireRepository repository;

  CheckQuestionnaireCompletionUseCase(this.repository);

  Future<bool> call(String userId) async {
    return await repository.hasUserCompletedQuestionnaire(userId);
  }
}
