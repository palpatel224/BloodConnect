part of 'find_request_bloc.dart';

abstract class FindRequestEvent extends Equatable {
  const FindRequestEvent();

  @override
  List<Object?> get props => [];
}

// Load all blood requests initially
class LoadRequests extends FindRequestEvent {}

// Change blood group filter
class BloodGroupChanged extends FindRequestEvent {
  final String bloodGroup;

  const BloodGroupChanged(this.bloodGroup);

  @override
  List<Object> get props => [bloodGroup];
}

// Change location filter
class LocationChanged extends FindRequestEvent {
  final String location;
  final String? placeId;

  const LocationChanged(this.location, this.placeId);

  @override
  List<Object?> get props => [location, placeId];
}

// Change radius filter
class RadiusChanged extends FindRequestEvent {
  final double radius;

  const RadiusChanged(this.radius);

  @override
  List<Object> get props => [radius];
}

// Perform search with current filters
class SearchRequests extends FindRequestEvent {
  final String bloodGroup;
  final String location;
  final String placeId;
  final double radius;

  const SearchRequests({
    required this.bloodGroup,
    required this.location,
    required this.placeId,
    required this.radius,
  });

  @override
  List<Object> get props => [bloodGroup, location, placeId, radius];
}
