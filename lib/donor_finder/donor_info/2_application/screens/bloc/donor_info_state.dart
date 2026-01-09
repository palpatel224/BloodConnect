part of 'donor_info_bloc.dart';

@immutable
sealed class DonorInfoState {}

final class DonorInfoInitial extends DonorInfoState {}

class DonorInfoLoading extends DonorInfoState {}

class DonorInfoLoaded extends DonorInfoState {
  final String? bloodGroup;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? location;
  final String? phoneNumber;
  final bool isFormValid;

  // Updated to use PlaceModel from the central implementation
  final List<PlaceModel> locationPredictions;
  final double? latitude;
  final double? longitude;
  final bool isSearching;

  DonorInfoLoaded({
    this.bloodGroup,
    this.dateOfBirth,
    this.gender,
    this.location,
    this.phoneNumber,
    this.isFormValid = false,
    this.locationPredictions = const [],
    this.latitude,
    this.longitude,
    this.isSearching = false,
  });

  DonorInfoLoaded copyWith({
    String? bloodGroup,
    DateTime? dateOfBirth,
    String? gender,
    String? location,
    String? phoneNumber,
    bool? isFormValid,
    List<PlaceModel>? locationPredictions,
    double? latitude,
    double? longitude,
    bool? isSearching,
  }) {
    return DonorInfoLoaded(
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isFormValid: isFormValid ?? this.isFormValid,
      locationPredictions: locationPredictions ?? this.locationPredictions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class DonorInfoError extends DonorInfoState {
  final String message;

  DonorInfoError(this.message);
}

class DonorInfoSubmissionInProgress extends DonorInfoState {}

class DonorInfoSubmissionSuccess extends DonorInfoState {}

class DonorInfoSubmissionFailure extends DonorInfoState {
  final String message;

  DonorInfoSubmissionFailure(this.message);
}
