import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/0_data/models/health_question_model.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/0_data/models/eligibility_result_model.dart';

abstract class HealthQuestionnaireDataSource {
  List<HealthQuestionModel> getHealthQuestions();
  EligibilityResultModel evaluateEligibility(List<HealthQuestionModel> answers);
  Future<void> saveEligibilityResult(String userId, bool isEligible);
  Future<bool> hasUserCompletedQuestionnaire(String userId);
}

class HealthQuestionnaireDataSourceImpl
    implements HealthQuestionnaireDataSource {
  final FirebaseFirestore firestore;

  HealthQuestionnaireDataSourceImpl(this.firestore);

  @override
  List<HealthQuestionModel> getHealthQuestions() {
    return [
      const HealthQuestionModel(
        id: 'q1',
        question: 'Are you at least 18 years old?',
        description: 'You must be at least 18 years old to donate blood.',
        isRequired: true,
      ),
      const HealthQuestionModel(
        id: 'q2',
        question: 'Do you weigh at least 50 kg?',
        description: 'Minimum weight requirement for blood donation is 50 kg.',
        isRequired: true,
      ),
      const HealthQuestionModel(
        id: 'q3',
        question:
            'Are you currently feeling healthy and free from fever or infection?',
        description:
            'You should be in good health without any symptoms of illness.',
        isRequired: true,
      ),
      const HealthQuestionModel(
        id: 'q4',
        question:
            'Have you donated blood in the last 3 months (for men) or 4 months (for women)?',
        description:
            'There must be adequate time between donations for your body to recover.',
        isRequired: true,
      ),
      const HealthQuestionModel(
        id: 'q5',
        question:
            'In the past 6 months, have you been diagnosed with or treated for any serious illness (e.g., hepatitis, malaria, HIV)?',
        description:
            'Certain medical conditions may affect your eligibility to donate.',
        isRequired: true,
      ),
    ];
  }

  @override
  EligibilityResultModel evaluateEligibility(
      List<HealthQuestionModel> answers) {
    List<String> reasons = [];
    bool isEligible = true;

    for (HealthQuestionModel answer in answers) {
      switch (answer.id) {
        case 'q1': // Age question
          if (answer.answer != true) {
            isEligible = false;
            reasons.add('Must be at least 18 years old');
          }
          break;
        case 'q2': // Weight question
          if (answer.answer != true) {
            isEligible = false;
            reasons.add('Must weigh at least 50 kg');
          }
          break;
        case 'q3': // Health status
          if (answer.answer != true) {
            isEligible = false;
            reasons.add(
                'Must be feeling healthy and free from fever or infection');
          }
          break;
        case 'q4': // Recent donation
          if (answer.answer == true) {
            isEligible = false;
            reasons.add('Must wait 3-4 months between donations');
          }
          break;
        case 'q5': // Serious illness
          if (answer.answer == true) {
            isEligible = false;
            reasons.add('Recent serious illness may affect eligibility');
          }
          break;
      }
    }

    String message;
    DateTime? nextEligibleDate;

    if (isEligible) {
      message =
          'Congratulations! You are eligible to donate blood. Your contribution can save lives!';
    } else {
      message =
          'Unfortunately, you are currently not eligible to donate blood based on your responses.';
      // Set next eligible date to 3 months from now if it's due to recent donation
      if (reasons.any((reason) => reason.contains('3-4 months'))) {
        nextEligibleDate = DateTime.now().add(const Duration(days: 90));
      }
    }

    return EligibilityResultModel(
      isEligible: isEligible,
      message: message,
      reasonsForIneligibility: reasons,
      nextEligibleDate: nextEligibleDate,
    );
  }

  @override
  Future<void> saveEligibilityResult(String userId, bool isEligible) async {
    try {
      // Update the donor's eligibility status in Donor_Finder collection
      await firestore.collection('Donor_Finder').doc(userId).set({
        'isEligible': isEligible,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save eligibility result: $e');
    }
  }

  @override
  Future<bool> hasUserCompletedQuestionnaire(String userId) async {
    try {
      final doc = await firestore.collection('Donor_Finder').doc(userId).get();

      if (!doc.exists) {
        return false;
      }

      final data = doc.data();
      // Check if isEligible field exists (not null)
      return data != null &&
          data.containsKey('isEligible') &&
          data['isEligible'] != null;
    } catch (e) {
      throw Exception('Failed to check questionnaire completion: $e');
    }
  }
}
