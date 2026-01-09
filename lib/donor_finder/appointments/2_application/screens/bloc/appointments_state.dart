part of 'appointments_bloc.dart';

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

final class AppointmentsInitial extends AppointmentsState {}

final class AppointmentsLoading extends AppointmentsState {}

final class AppointmentCreated extends AppointmentsState {
  final String appointmentId;

  const AppointmentCreated({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

final class AppointmentCreationFailed extends AppointmentsState {
  final String message;

  const AppointmentCreationFailed({required this.message});

  @override
  List<Object> get props => [message];
}

final class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;

  const AppointmentsLoaded({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

final class AppointmentLoaded extends AppointmentsState {
  final Appointment appointment;

  const AppointmentLoaded({required this.appointment});

  @override
  List<Object> get props => [appointment];
}

final class AppointmentUpdated extends AppointmentsState {
  final String appointmentId;

  const AppointmentUpdated({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

final class AppointmentDeleted extends AppointmentsState {
  final String appointmentId;

  const AppointmentDeleted({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}

final class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError({required this.message});

  @override
  List<Object> get props => [message];
}
