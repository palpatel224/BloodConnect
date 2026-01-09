part of 'request_screen_bloc.dart';

sealed class RequestScreenEvent extends Equatable {
  const RequestScreenEvent();

  @override
  List<Object> get props => [];
}

class RequestScreenSubmitRequested extends RequestScreenEvent {
  final String patientName;
  final String bloodType;
  final int units;
  final String hospital;
  final String urgencyLevel;
  final String reason;
  final String contactNumber;
  final String additionalInfo;
  final bool isEmergency;
  final double? latitude;
  final double? longitude;
  final String? placeId;

  const RequestScreenSubmitRequested({
    required this.patientName,
    required this.bloodType,
    required this.units,
    required this.hospital,
    required this.urgencyLevel,
    required this.reason,
    required this.contactNumber,
    required this.additionalInfo,
    required this.isEmergency,
    this.latitude,
    this.longitude,
    this.placeId,
  });

  @override
  List<Object> get props => [
        patientName,
        bloodType,
        units,
        hospital,
        urgencyLevel,
        reason,
        contactNumber,
        additionalInfo,
        isEmergency,
      ];
}
