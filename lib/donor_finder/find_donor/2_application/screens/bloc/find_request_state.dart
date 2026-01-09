part of 'find_request_bloc.dart';

abstract class FindRequestState extends Equatable {
  const FindRequestState();

  @override
  List<Object?> get props => [];
}

class FindRequestInitial extends FindRequestState {}

class FindRequestLoading extends FindRequestState {}

class FindRequestError extends FindRequestState {
  final String message;

  const FindRequestError(this.message);

  @override
  List<Object> get props => [message];
}

class FindRequestLoaded extends FindRequestState {
  final List<BloodRequestEntity> requests;
  final String selectedBloodGroup;
  final String location;
  final String? placeId;
  final double radius;

  const FindRequestLoaded({
    required this.requests,
    this.selectedBloodGroup = '',
    this.location = '',
    this.placeId,
    this.radius = 10.0,
  });

  FindRequestLoaded copyWith({
    List<BloodRequestEntity>? requests,
    String? selectedBloodGroup,
    String? location,
    String? placeId,
    double? radius,
  }) {
    return FindRequestLoaded(
      requests: requests ?? this.requests,
      selectedBloodGroup: selectedBloodGroup ?? this.selectedBloodGroup,
      location: location ?? this.location,
      placeId: placeId ?? this.placeId,
      radius: radius ?? this.radius,
    );
  }

  @override
  List<Object?> get props =>
      [requests, selectedBloodGroup, location, placeId, radius];
}
