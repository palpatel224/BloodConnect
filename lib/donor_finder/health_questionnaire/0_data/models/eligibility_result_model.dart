import 'package:bloodconnect/donor_finder/health_questionnaire/1_domain/entities/eligibility_result_entity.dart';

class EligibilityResultModel extends EligibilityResultEntity {
  const EligibilityResultModel({
    required super.isEligible,
    required super.message,
    required super.reasonsForIneligibility,
    super.nextEligibleDate,
  });

  factory EligibilityResultModel.fromEntity(EligibilityResultEntity entity) {
    return EligibilityResultModel(
      isEligible: entity.isEligible,
      message: entity.message,
      reasonsForIneligibility: entity.reasonsForIneligibility,
      nextEligibleDate: entity.nextEligibleDate,
    );
  }
}
