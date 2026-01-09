import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String userId;
  final String donorId;
  final String name;
  final String bloodType;
  final String phoneNumber;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String hospital;
  final String notes;
  final DateTime createdAt;
  final String status;
  final double latitude; // Hospital location latitude for geoqueries
  final double longitude; // Hospital location longitude for geoqueries

  const Appointment({
    required this.id,
    required this.userId,
    required this.donorId,
    required this.name,
    required this.bloodType,
    required this.phoneNumber,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.hospital,
    required this.notes,
    required this.createdAt,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [
        userId,
        donorId,
        name,
        bloodType,
        phoneNumber,
        appointmentDate,
        appointmentTime,
        hospital,
        notes,
        createdAt,
        status,
        latitude,
        longitude,
      ];
}
