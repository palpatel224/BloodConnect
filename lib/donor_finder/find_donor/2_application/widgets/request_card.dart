import 'package:flutter/material.dart';
import '../../../request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class RequestCard extends StatelessWidget {
  final String patientName;
  final String bloodType;
  final int units;
  final String hospital;
  final RequestStatus requestStatus;
  final VoidCallback? onSharePressed;
  final String contactNumber;
  final VoidCallback? onApplyPressed;
  final String? reason;
  final String? distance;
  final String? timePosted;
  final String urgencyLevel;

  const RequestCard({
    super.key,
    required this.patientName,
    required this.bloodType,
    required this.units,
    required this.hospital,
    required this.requestStatus,
    this.onSharePressed,
    required this.contactNumber,
    this.onApplyPressed,
    this.reason,
    this.distance,
    this.timePosted,
    this.urgencyLevel = 'Medium',
  });

  String _getRequestStatusText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }

  Color _getRequestStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
    }
  }

  String _getUrgencyText() {
    if (requestStatus == RequestStatus.approved) {
      return 'Approved';
    } else {
      return urgencyLevel;
    }
  }

  Color _getUrgencyColor() {
    if (requestStatus == RequestStatus.approved) {
      return Colors.green;
    } else {
      switch (urgencyLevel) {
        case 'High':
          return Colors.red;
        case 'Medium':
          return Colors.orange;
        case 'Low':
          return Colors.green;
        default:
          return Colors.orange;
      }
    }
  }

  // Get background color with low opacity for urgency chip
  Color _getUrgencyBackgroundColor() {
    if (requestStatus == RequestStatus.approved) {
      return Colors.green.shade50;
    } else {
      switch (urgencyLevel) {
        case 'High':
          return Colors.red.shade50;
        case 'Medium':
          return Colors.orange.shade50;
        case 'Low':
          return Colors.green.shade50;
        default:
          return Colors.orange.shade50;
      }
    }
  }

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: contactNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $phoneUri');
    }
  }

  Future<void> _openMaps() async {
    try {
      await MapsLauncher.launchQuery(hospital);
    } catch (e) {
      debugPrint('Could not launch maps: $e');
    }
  }

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
            // Header with patient name and time/urgency
            Row(
              children: [
                // Patient name and time posted
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (timePosted != null)
                        Text(
                          timePosted!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),

                // Urgency chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getUrgencyBackgroundColor(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getUrgencyText(),
                    style: TextStyle(
                      fontSize: 13,
                      color: _getUrgencyColor(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Blood type and units
            Row(
              children: [
                // Blood type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                // Blood type text
                Text(
                  bloodType,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Spacer(),
                // Units
                Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "$units units",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Hospital and distance
            Row(
              children: [
                // Hospital icon
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                // Hospital name
                Expanded(
                  flex:
                      2, // Reduce the flex to make hospital name take less space
                  child: Text(
                    hospital,
                    style: TextStyle(
                      fontSize: 13, // Smaller font size
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Add extra spacing between hospital and distance
                const SizedBox(width: 12),
                // Distance
                if (distance != null)
                  Expanded(
                    flex: 1, // Give distance a dedicated portion of space
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigation_outlined,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Reason
            if (reason != null)
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
                      "Reason: $reason",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
                    onPressed: _makePhoneCall,
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
                    onPressed: _openMaps,
                    icon: const Icon(
                      Icons.map,
                      size: 16,
                      color: Colors.black,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
