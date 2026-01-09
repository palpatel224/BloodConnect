import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:equatable/equatable.dart';

abstract class AppointmentListState extends Equatable {
  const AppointmentListState();

  @override
  List<Object> get props => [];
}

class AppointmentListInitial extends AppointmentListState {
  const AppointmentListInitial();
}

class AppointmentListLoading extends AppointmentListState {
  const AppointmentListLoading();
}

class AppointmentListLoaded extends AppointmentListState {
  final List<Appointment> appointments;
  final List<Appointment> allAppointments;
  final String? location;
  final double radius;
  final bool isLocationSearch;
  final String? filterStatus;

  const AppointmentListLoaded({
    required this.appointments,
    required this.allAppointments,
    this.location,
    this.radius = 10.0,
    this.isLocationSearch = false,
    this.filterStatus,
  });

  @override
  List<Object> get props {
    List<Object> propsList = [
      appointments,
      allAppointments,
      radius,
      isLocationSearch
    ];
    if (location != null) propsList.add(location!);
    if (filterStatus != null) propsList.add(filterStatus!);
    return propsList;
  }

  AppointmentListLoaded copyWith({
    List<Appointment>? appointments,
    List<Appointment>? allAppointments,
    String? location,
    double? radius,
    bool? isLocationSearch,
    String? filterStatus,
  }) {
    return AppointmentListLoaded(
      appointments: appointments ?? this.appointments,
      allAppointments: allAppointments ?? this.allAppointments,
      location: location ?? this.location,
      radius: radius ?? this.radius,
      isLocationSearch: isLocationSearch ?? this.isLocationSearch,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}

class AppointmentListError extends AppointmentListState {
  final String message;

  const AppointmentListError(this.message);

  @override
  List<Object> get props => [message];
}
