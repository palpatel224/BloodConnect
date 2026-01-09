import 'package:equatable/equatable.dart';

class WorkerInfo extends Equatable {
  final String id;
  final String name;
  final String profession;
  final String location;
  final String institutionName;
  final double? latitude;
  final double? longitude;
  final String? placeId;

  const WorkerInfo({
    required this.id,
    required this.name,
    required this.profession,
    required this.location,
    required this.institutionName,
    this.latitude,
    this.longitude,
    this.placeId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        profession,
        location,
        institutionName,
        latitude,
        longitude,
        placeId
      ];
}
