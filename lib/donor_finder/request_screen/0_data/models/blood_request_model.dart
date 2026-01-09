import 'package:cloud_firestore/cloud_firestore.dart';
import '../../1_domain/entities/blood_request_entity.dart';

class BloodRequestModel extends BloodRequestEntity {
  const BloodRequestModel({
    super.id,
    required super.patientName,
    required super.bloodType,
    required super.units,
    required super.hospital,
    required super.urgencyLevel,
    required super.reason,
    required super.contactNumber,
    super.additionalInfo,
    required super.isEmergency,
    super.requestStatus = RequestStatus.pending,
    super.latitude,
    super.longitude,
    super.placeId,
    super.createdAt,
  });

  factory BloodRequestModel.fromEntity(BloodRequestEntity entity) {
    return BloodRequestModel(
      id: entity.id,
      patientName: entity.patientName,
      bloodType: entity.bloodType,
      units: entity.units,
      hospital: entity.hospital,
      urgencyLevel: entity.urgencyLevel,
      reason: entity.reason,
      contactNumber: entity.contactNumber,
      additionalInfo: entity.additionalInfo,
      isEmergency: entity.isEmergency,
      requestStatus: entity.requestStatus,
      latitude: entity.latitude,
      longitude: entity.longitude,
      placeId: entity.placeId,
      createdAt: entity.createdAt,
    );
  }

  // Convert to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'bloodType': bloodType,
      'units': units,
      'hospital': hospital,
      'urgencyLevel': urgencyLevel,
      'reason': reason,
      'contactNumber': contactNumber,
      'additionalInfo': additionalInfo,
      'isEmergency': isEmergency,
      'requestStatus': requestStatus.name, // Store enum as string
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
      'createdAt': createdAt ?? Timestamp.now(),
    };
  }

  // Create from a Firebase document
  factory BloodRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BloodRequestModel(
      id: doc.id,
      patientName: data['patientName'] ?? '',
      bloodType: data['bloodType'] ?? '',
      units: data['units'] ?? 1,
      hospital: data['hospital'] ?? '',
      urgencyLevel: data['urgencyLevel'] ?? 'Medium',
      reason: data['reason'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      additionalInfo: data['additionalInfo'] ?? '',
      isEmergency: data['isEmergency'] ?? false,
      requestStatus: RequestStatus.values.firstWhere(
        (e) => e.name == data['requestStatus'],
        orElse: () => RequestStatus.pending,
      ),
      latitude: data['latitude'],
      longitude: data['longitude'],
      placeId: data['placeId'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
