import 'package:cloud_firestore/cloud_firestore.dart';
import '../../1_domain/entities/donor_entity.dart';

class DonorModel extends DonorEntity {
  const DonorModel({
    required super.id,
    required super.name,
    required super.dateOfBirth,
    required super.bloodType,
    required super.address,
    required super.phoneNumber,
    super.latitude,
    super.longitude,
  });

  // Convert Firestore document to DonorModel
  factory DonorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    // Parse date of birth
    DateTime dob;
    try {
      dob = data['dateOfBirth'] is Timestamp
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : DateTime.parse(data['dateOfBirth'].toString());
    } catch (e) {
      // Default to current date if parsing fails
      dob = DateTime.now();
    }

    return DonorModel(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      dateOfBirth: dob,
      bloodType: data['bloodType'] ?? 'Unknown',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
    );
  }

  // Convert DonorModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'bloodType': bloodType,
      'address': address,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Factory method to create DonorModel from DonorEntity
  factory DonorModel.fromEntity(DonorEntity entity) {
    return DonorModel(
      id: entity.id,
      name: entity.name,
      dateOfBirth: entity.dateOfBirth,
      bloodType: entity.bloodType,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
