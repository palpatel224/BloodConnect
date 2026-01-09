import 'package:equatable/equatable.dart';

class DonorEntity extends Equatable {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String bloodType;
  final String address;
  final String phoneNumber;
  final double? latitude;
  final double? longitude;

  const DonorEntity({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.bloodType,
    required this.address,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
  });

  // Calculates age based on date of birth
  int get age {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        dateOfBirth,
        bloodType,
        address,
        phoneNumber,
        latitude,
        longitude
      ];
}
