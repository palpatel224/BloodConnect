import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel(
      {required super.userId,
      required super.donorId,
      required super.name,
      required super.bloodType,
      required super.phoneNumber,
      required super.appointmentDate,
      required super.appointmentTime,
      required super.hospital,
      required super.notes,
      required super.createdAt,
      required super.id,
      required super.status,
      required super.latitude,
      required super.longitude});

  // Define constants for status values to ensure consistency
  static const String STATUS_PENDING = 'Pending';
  static const String STATUS_COMPLETED = 'Completed';
  static const String STATUS_CANCELLED = 'Cancelled';

  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      userId: appointment.userId,
      donorId: appointment.donorId,
      name: appointment.name,
      bloodType: appointment.bloodType,
      phoneNumber: appointment.phoneNumber,
      appointmentDate: appointment.appointmentDate,
      appointmentTime: appointment.appointmentTime,
      hospital: appointment.hospital,
      notes: appointment.notes,
      createdAt: appointment.createdAt,
      status: appointment.status,
      latitude: appointment.latitude,
      longitude: appointment.longitude,
    );
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // Handle potential null values for latitude and longitude
    double lat = 0.0;
    double lng = 0.0;

    if (json['latitude'] != null) {
      lat = (json['latitude'] is double)
          ? json['latitude']
          : double.tryParse(json['latitude'].toString()) ?? 0.0;
    } else if (json['location'] != null && json['location'] is GeoPoint) {
      lat = (json['location'] as GeoPoint).latitude;
    }

    if (json['longitude'] != null) {
      lng = (json['longitude'] is double)
          ? json['longitude']
          : double.tryParse(json['longitude'].toString()) ?? 0.0;
    } else if (json['location'] != null && json['location'] is GeoPoint) {
      lng = (json['location'] as GeoPoint).longitude;
    }

    return AppointmentModel(
      id: json['id'],
      userId: json['userId'],
      donorId: json['donorId'] ?? '',
      name: json['name'],
      bloodType: json['bloodType'],
      phoneNumber: json['phoneNumber'],
      appointmentDate: (json['appointmentDate'] as Timestamp).toDate(),
      appointmentTime: json['appointmentTime'],
      hospital: json['hospital'],
      notes: json['notes'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      status: json['status'] ?? STATUS_PENDING,
      latitude: lat,
      longitude: lng,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'donorId': donorId,
      'name': name,
      'bloodType': bloodType,
      'phoneNumber': phoneNumber,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'appointmentTime': appointmentTime,
      'hospital': hospital,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      // Add GeoPoint for Firestore geoqueries
      'location': GeoPoint(latitude, longitude),
    };
  }
}
