import 'package:bloodconnect/donor_finder/appointments/1_domain/entities/appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with donor name and status
            Row(
              children: [
                // Donor name and appointment date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy')
                            .format(appointment.appointmentDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Status chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusBackgroundColor(appointment.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      fontSize: 13,
                      color: _getStatusColor(appointment.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Blood type and appointment time
            Row(
              children: [
                // Blood type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                // Blood type text
                Text(
                  appointment.bloodType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Spacer(),
                // Time
                Icon(
                  Icons.access_time,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  appointment.appointmentTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Hospital
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.hospital,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Notes if available
            if (appointment.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Notes: ${appointment.notes}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Donor ID
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "Donor ID: ${appointment.donorId}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(appointment.phoneNumber),
                    icon: const Icon(
                      Icons.call,
                      size: 16,
                    ),
                    label: const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchMaps(appointment.hospital,
                        appointment.latitude, appointment.longitude),
                    icon: const Icon(
                      Icons.map,
                      size: 16,
                    ),
                    label: const Text(
                      'Maps',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (appointment.status.toLowerCase() != 'completed') ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _verifyAppointment(context),
                      icon: const Icon(
                        Icons.verified_user,
                        size: 16,
                      ),
                      label: const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[50],
                        foregroundColor: Colors.green,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      case 'pending':
      default:
        return Colors.orange.shade50;
    }
  }

  void _launchMaps(String hospital, double latitude, double longitude) {
    if (latitude != 0 && longitude != 0) {
      MapsLauncher.launchCoordinates(latitude, longitude, hospital);
    } else {
      MapsLauncher.launchQuery(hospital);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _verifyAppointment(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD32F2F),
            ),
          );
        },
      );

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // 1. Update appointment status to "Completed"
      await firestore
          .collection('Appointments')
          .doc(appointment.id)
          .update({'status': 'Completed'});

      // 2. Get the donor document
      final donorDoc = await firestore
          .collection('Donor_Finder')
          .doc(appointment.userId)
          .get();

      if (donorDoc.exists) {
        // 3. Update donor credits (add 10)
        // Fix the type issue by ensuring we're using an integer
        final currentCredits = (donorDoc.data()?['credits'] ?? 0) is int
            ? (donorDoc.data()?['credits'] ?? 0)
            : int.tryParse(donorDoc.data()?['credits']?.toString() ?? '0') ?? 0;

        await firestore
            .collection('Donor_Finder')
            .doc(appointment.userId)
            .update({'credits': currentCredits + 10});
      }

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment verified and 10 credits added to donor'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
