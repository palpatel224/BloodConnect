import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final patientName;
  final String time;
  final String bloodType;
  final String priority;
  const RequestCard(
      {super.key,
      this.patientName,
      required this.time,
      required this.bloodType,
      required this.priority});

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = Colors.red.shade100;
        break;
      case 'Medium':
        priorityColor = Colors.amber.shade100;
        break;
      case 'Low':
        priorityColor = Colors.green.shade100;
        break;
      default:
        priorityColor = Colors.grey.shade100;
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        patientName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(time),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              bloodType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              priority,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: priority == 'High'
                    ? Colors.red.shade800
                    : priority == 'Medium'
                        ? Colors.amber.shade800
                        : Colors.green.shade800,
              ),
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
