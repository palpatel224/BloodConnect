import 'package:bloodconnect/health_worker/worker_info/1_domain/entities/worker_info_entity.dart';

class WorkerInfoModel extends WorkerInfo {
  const WorkerInfoModel({
    required super.id,
    required super.name,
    required super.profession,
    required super.location,
    required super.institutionName,
    super.latitude,
    super.longitude,
    super.placeId,
  });

  factory WorkerInfoModel.fromJson(Map<String, dynamic> json) {
    return WorkerInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profession: json['profession'] as String,
      location: json['location'] as String,
      institutionName: json['institutionName'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      placeId: json['placeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profession': profession,
      'location': location,
      'institutionName': institutionName,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }

  factory WorkerInfoModel.fromDomain(WorkerInfo workerInfo) {
    return WorkerInfoModel(
      id: workerInfo.id,
      name: workerInfo.name,
      profession: workerInfo.profession,
      location: workerInfo.location,
      institutionName: workerInfo.institutionName,
      latitude: workerInfo.latitude,
      longitude: workerInfo.longitude,
      placeId: workerInfo.placeId,
    );
  }
}
