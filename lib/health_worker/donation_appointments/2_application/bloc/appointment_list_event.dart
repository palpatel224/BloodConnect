import 'package:equatable/equatable.dart';

abstract class AppointmentListEvent extends Equatable {
  const AppointmentListEvent();

  @override
  List<Object> get props => [];
}

class FetchAppointments extends AppointmentListEvent {
  const FetchAppointments();
}

class LocationChanged extends AppointmentListEvent {
  final String location;
  final String placeId;

  const LocationChanged({
    required this.location,
    required this.placeId,
  });

  @override
  List<Object> get props => [location, placeId];
}

class RadiusChanged extends AppointmentListEvent {
  final double radius;

  const RadiusChanged(this.radius);

  @override
  List<Object> get props => [radius];
}

class SearchAppointmentsByLocation extends AppointmentListEvent {
  final String location;
  final String placeId;
  final double radius;

  const SearchAppointmentsByLocation({
    required this.location,
    required this.placeId,
    required this.radius,
  });

  @override
  List<Object> get props => [location, placeId, radius];
}

class FilterAppointmentsByStatus extends AppointmentListEvent {
  final String? status;

  const FilterAppointmentsByStatus({this.status});

  @override
  List<Object> get props => status != null ? [status!] : [];
}
