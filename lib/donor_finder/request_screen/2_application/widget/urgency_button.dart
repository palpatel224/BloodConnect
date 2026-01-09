import 'package:flutter/material.dart';

class UrgencyButton extends StatelessWidget {
  final String level;
  final Color bgColor;
  final Color textColor;
  final bool isSelected;
  final VoidCallback onTap;

  const UrgencyButton({
    super.key,
    required this.level,
    required this.bgColor,
    required this.textColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? textColor : Colors.transparent,
              width: isSelected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            level,
            style: TextStyle(
              color: level == 'Low' ? Colors.green : textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
