import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:maps_launcher/maps_launcher.dart';

class UrgentRequestCard extends StatelessWidget {
  final BloodRequestEntity request;
  final String distance;

  const UrgentRequestCard({
    super.key,
    required this.request,
    this.distance = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE8E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.bloodType,
                    style: const TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _getTimePosted(request.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              request.patientName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.hospital,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (distance.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Text(
                    distance,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _contactRequester(context, request.contactNumber),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      "Contact",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openMaps(request.hospital),
                    icon: const Icon(
                      Icons.map,
                      size: 16,
                      color: Color(0xFFD32F2F),
                    ),
                    label: const Text(
                      "Maps",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE8E8),
                      foregroundColor: const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
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

  String _getTimePosted(DateTime? createdAt) {
    if (createdAt == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  void _contactRequester(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Shows error dialog if phone app can't be launched
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Could not launch phone dialer. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _openMaps(String address) async {
    try {
      await MapsLauncher.launchQuery(address);
    } catch (e) {
      debugPrint('Could not launch maps: $e');
    }
  }
}
