import 'package:flutter/material.dart';

class BloodTypeGrid extends StatelessWidget {
  final String selectedBloodType;
  final Function(String) onBloodTypeSelected;

  const BloodTypeGrid({
    super.key,
    required this.selectedBloodType,
    required this.onBloodTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: bloodTypes.map((type) {
        final isSelected = selectedBloodType == type;
        return GestureDetector(
          onTap: () {
            onBloodTypeSelected(type);
          },
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.red : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Colors.red.withOpacity(0.1) : Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.red : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
