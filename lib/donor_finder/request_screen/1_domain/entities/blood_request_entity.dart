import 'package:equatable/equatable.dart';

enum RequestStatus { pending, approved, rejected }

class BloodRequestEntity extends Equatable {
  final String? id;
  final String patientName;
  final String bloodType;
  final int units;
  final String hospital;
  final String urgencyLevel;
  final String reason;
  final String contactNumber;
  final String additionalInfo;
  final bool isEmergency;
  final RequestStatus requestStatus;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final DateTime? createdAt;

  const BloodRequestEntity({
    this.id,
    required this.patientName,
    required this.bloodType,
    required this.units,
    required this.hospital,
    required this.urgencyLevel,
    required this.reason,
    required this.contactNumber,
    this.additionalInfo = '',
    required this.isEmergency,
    this.requestStatus = RequestStatus.pending,
    this.latitude,
    this.longitude,
    this.placeId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        patientName,
        bloodType,
        units,
        hospital,
        urgencyLevel,
        reason,
        contactNumber,
        additionalInfo,
        isEmergency,
        requestStatus,
        latitude,
        longitude,
        placeId,
        createdAt,
      ];
}
