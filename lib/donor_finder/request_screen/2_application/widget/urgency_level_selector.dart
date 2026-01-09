import 'package:flutter/material.dart';
import 'urgency_button.dart';

class UrgencyLevelSelector extends StatelessWidget {
  final String selectedUrgency;
  final Function(String) onUrgencySelected;

  const UrgencyLevelSelector({
    super.key,
    required this.selectedUrgency,
    required this.onUrgencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UrgencyButton(
          level: 'Low',
          bgColor: Colors.green.shade50,
          textColor: Colors.green,
          isSelected: selectedUrgency == 'Low',
          onTap: () => onUrgencySelected('Low'),
        ),
        const SizedBox(width: 8),
        UrgencyButton(
          level: 'Medium',
          bgColor: Colors.orange.shade50,
          textColor: Colors.red,
          isSelected: selectedUrgency == 'Medium',
          onTap: () => onUrgencySelected('Medium'),
        ),
        const SizedBox(width: 8),
        UrgencyButton(
          level: 'High',
          bgColor: Colors.red.shade50,
          textColor: Colors.red,
          isSelected: selectedUrgency == 'High',
          onTap: () => onUrgencySelected('High'),
        ),
      ],
    );
  }
}
