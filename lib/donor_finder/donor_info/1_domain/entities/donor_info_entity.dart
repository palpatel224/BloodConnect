import 'package:equatable/equatable.dart';

class DonorInfo extends Equatable {
  final String userId;
  final String name;
  final DateTime dateOfBirth;
  final String bloodType;
  final String address;
  final String phoneNumber;
  final double? latitude;
  final double? longitude;
  final int credits;
  final bool? isEligible; // null means questionnaire not completed

  const DonorInfo({
    required this.userId,
    required this.name,
    required this.dateOfBirth,
    required this.bloodType,
    required this.address,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
    this.credits = 0,
    this.isEligible,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        dateOfBirth,
        bloodType,
        address,
        phoneNumber,
        latitude,
        longitude,
        credits,
        isEligible,
      ];
}
