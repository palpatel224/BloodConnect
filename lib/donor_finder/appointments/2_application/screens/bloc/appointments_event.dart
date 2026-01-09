part of 'appointments_bloc.dart';

sealed class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object> get props => [];
}

class CreateAppointmentEvent extends AppointmentsEvent {
  final String donorId;
  final String name;
  final String bloodType;
  final String phoneNumber;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final String hospital;
  final String notes;
  final String status;
  final double latitude;
  final double longitude;

  const CreateAppointmentEvent({
    required this.donorId,
    required this.name,
    required this.bloodType,
    required this.phoneNumber,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.hospital,
    required this.notes,
    required this.latitude,
    required this.longitude,
    this.status = 'Pending', // Default to Pending
  });

  @override
  List<Object> get props => [
        donorId,
        name,
        bloodType,
        phoneNumber,
        appointmentDate,
        appointmentTime,
        hospital,
        notes,
        status,
        latitude,
        longitude,
      ];
}

class GetUserAppointmentsEvent extends AppointmentsEvent {
  final String userId;

  const GetUserAppointmentsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetSingleAppointmentEvent extends AppointmentsEvent {
  final String appointmentId;

  const GetSingleAppointmentEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

class UpdateAppointmentEvent extends AppointmentsEvent {
  final String appointmentId;
  final DateTime? appointmentDate;
  final TimeOfDay? appointmentTime;
  final String? status;
  final String? notes;
  final double? latitude;
  final double? longitude;

  const UpdateAppointmentEvent({
    required this.appointmentId,
    this.appointmentDate,
    this.appointmentTime,
    this.status,
    this.notes,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object> get props {
    List<Object> props = [appointmentId];
    if (appointmentDate != null) props.add(appointmentDate!);
    if (appointmentTime != null) props.add(appointmentTime!);
    if (status != null) props.add(status!);
    if (notes != null) props.add(notes!);
    if (latitude != null) props.add(latitude!);
    if (longitude != null) props.add(longitude!);
    return props;
  }
}

class DeleteAppointmentEvent extends AppointmentsEvent {
  final String appointmentId;

  const DeleteAppointmentEvent({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}
