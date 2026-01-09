class HomeScreenAppointmentEntity {
  final String id;
  final String date;
  final String time;
  final String location;
  final String status; // "Completed" or "Pending"
  final String distance;
  final String bloodAmount;
  final DateTime appointmentDateTime;

  HomeScreenAppointmentEntity({
    required this.id,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.distance,
    required this.bloodAmount,
    required this.appointmentDateTime,
  });
}
