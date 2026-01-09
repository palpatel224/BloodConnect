part of 'health_worker_info_bloc.dart';

sealed class HealthWorkerInfoEvent extends Equatable {
  const HealthWorkerInfoEvent();

  @override
  List<Object> get props => [];
}

class SubmitHealthWorkerInfo extends HealthWorkerInfoEvent {
  final String name;
  final String profession;
  final String location;
  final String institution;
  final double? latitude;
  final double? longitude;
  final String? placeId;

  const SubmitHealthWorkerInfo({
    required this.name,
    required this.profession,
    required this.location,
    required this.institution,
    this.latitude,
    this.longitude,
    this.placeId,
  });

  @override
  List<Object> get props => [
        name,
        profession,
        location,
        institution,
        if (latitude != null) latitude!,
        if (longitude != null) longitude!,
        if (placeId != null) placeId!,
      ];
}
