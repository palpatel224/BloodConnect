import 'package:bloodconnect/donor_finder/appointments/2_application/screens/donation_form_screen.dart';
import 'package:flutter/material.dart';

class DonationEligibilityCard extends StatelessWidget {
  final bool isEligibleToDonate;
  final String nextEligibleDate;
  final int daysUntilEligible;

  const DonationEligibilityCard({
    super.key,
    required this.isEligibleToDonate,
    required this.nextEligibleDate,
    required this.daysUntilEligible,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isEligibleToDonate
                        ? Color(0xFFE8F5E9)
                        : Color(0xFFFEE8E8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isEligibleToDonate ? Icons.check_circle : Icons.timer,
                    color:
                        isEligibleToDonate ? Colors.green : Color(0xFFD32F2F),
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEligibleToDonate
                            ? "You're eligible to donate"
                            : "You're not eligible yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isEligibleToDonate
                              ? Colors.green
                              : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        isEligibleToDonate
                            ? "You can schedule a donation now"
                            : "You can donate again after $nextEligibleDate",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isEligibleToDonate) ...[
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: 1 - (daysUntilEligible / 90), // Assuming 90-day cycle
                backgroundColor: Colors.grey[200],
                color: Color(0xFFD32F2F),
              ),
              SizedBox(height: 8),
              Text(
                "$daysUntilEligible days remaining",
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isEligibleToDonate
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonationFormScreen()));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isEligibleToDonate ? Color(0xFFD32F2F) : Colors.grey[300],
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                isEligibleToDonate ? "Schedule Donation" : "Not Eligible Yet",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
