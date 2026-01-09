import 'package:flutter/material.dart';

class RecentDonation {
  final String date;
  final String location;
  final String amount;

  RecentDonation({
    required this.date,
    required this.location,
    required this.amount,
  });
}

class DonationHistoryCard extends StatelessWidget {
  final RecentDonation donation;

  const DonationHistoryCard({
    super.key,
    required this.donation,
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
                Icons.water_drop,
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
                    donation.date,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    donation.location,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Amount: ${donation.amount}",
                    style: TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
