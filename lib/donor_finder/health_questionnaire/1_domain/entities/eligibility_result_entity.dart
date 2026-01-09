import 'package:equatable/equatable.dart';

class EligibilityResultEntity extends Equatable {
  final bool isEligible;
  final String message;
  final List<String> reasonsForIneligibility;
  final DateTime? nextEligibleDate;

  const EligibilityResultEntity({
    required this.isEligible,
    required this.message,
    required this.reasonsForIneligibility,
    this.nextEligibleDate,
  });

  @override
  List<Object?> get props =>
      [isEligible, message, reasonsForIneligibility, nextEligibleDate];
}
