import '../../1_domain/entities/donor_info_entity.dart';

class DonorInfoModel extends DonorInfo {
  const DonorInfoModel({
    required super.userId,
    required super.name,
    required super.dateOfBirth,
    required super.bloodType,
    required super.address,
    required super.phoneNumber,
    super.latitude,
    super.longitude,
    super.credits = 0,
    super.isEligible,
  });

  factory DonorInfoModel.fromJson(Map<String, dynamic> json) {
    return DonorInfoModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      bloodType: json['bloodType'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      latitude: json['latitude'] != null ? json['latitude'] as double : null,
      longitude: json['longitude'] != null ? json['longitude'] as double : null,
      credits: json['credits'] != null ? json['credits'] as int : 0,
      isEligible:
          json['isEligible'] != null ? json['isEligible'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'bloodType': bloodType,
      'address': address,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'credits': credits,
      'isEligible': isEligible,
    };
  }

  factory DonorInfoModel.fromDomain(DonorInfo donorInfo) {
    return DonorInfoModel(
      userId: donorInfo.userId,
      name: donorInfo.name,
      dateOfBirth: donorInfo.dateOfBirth,
      bloodType: donorInfo.bloodType,
      address: donorInfo.address,
      phoneNumber: donorInfo.phoneNumber,
      latitude: donorInfo.latitude,
      longitude: donorInfo.longitude,
      credits: donorInfo.credits,
      isEligible: donorInfo.isEligible,
    );
  }

  DonorInfo toDomain() {
    return DonorInfo(
      userId: userId,
      name: name,
      dateOfBirth: dateOfBirth,
      bloodType: bloodType,
      address: address,
      phoneNumber: phoneNumber,
      latitude: latitude,
      longitude: longitude,
      credits: credits,
      isEligible: isEligible,
    );
  }
}
