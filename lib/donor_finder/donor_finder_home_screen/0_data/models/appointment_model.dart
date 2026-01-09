import 'package:cloud_firestore/cloud_firestore.dart';
import '../../1_domain/entities/appointment_entity.dart';

class HomeScreenAppointmentModel extends HomeScreenAppointmentEntity {
  HomeScreenAppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    required super.location,
    required super.status,
    required super.distance,
    required super.bloodAmount,
    required super.appointmentDateTime,
  });

  factory HomeScreenAppointmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Parse date from Firestore Timestamp to DateTime
    DateTime appointmentDateTime;
    if (data['appointmentDateTime'] is Timestamp) {
      appointmentDateTime = (data['appointmentDateTime'] as Timestamp).toDate();
    } else {
      appointmentDateTime = DateTime.now(); // Fallback
    }

    // Format the date and time strings
    String formattedDate =
        "${appointmentDateTime.day}/${appointmentDateTime.month}/${appointmentDateTime.year}";
    String formattedTime =
        "${appointmentDateTime.hour}:${appointmentDateTime.minute.toString().padLeft(2, '0')}";

    // Calculate distance (would typically be done with geolocation in a real app)
    String distance = data['distance'] ?? "Unknown";

    return HomeScreenAppointmentModel(
      id: doc.id,
      date: data['date'] ?? formattedDate,
      time: data['time'] ?? formattedTime,
      location: data['location'] ?? "Unknown",
      status: data['appointmentStatus'] ?? "Pending",
      distance: distance,
      bloodAmount: data['bloodAmount'] ?? "450 ml",
      appointmentDateTime: appointmentDateTime,
    );
  }
}
