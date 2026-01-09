import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Color color;
  final int count;
  final String title;
  final IconData icon;
  
  const StatCard({
    super.key,
    required this.color,
    required this.count,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize:
            MainAxisSize.min, // Ensure column takes minimum space needed
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
