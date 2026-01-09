import 'package:flutter/material.dart';

class UpcomingAppointment {
  final String date;
  final String time;
  final String location;
  final String distance;

  UpcomingAppointment({
    required this.date,
    required this.time,
    required this.location,
    required this.distance,
  });
}

class AppointmentCard extends StatelessWidget {
  final UpcomingAppointment appointment;

  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFFEE8E8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month,
                color: Color(0xFFD32F2F),
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.date,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    appointment.time,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${appointment.location} (${appointment.distance})",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
