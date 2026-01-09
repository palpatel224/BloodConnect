import 'package:flutter/material.dart';
import 'unit_control_button.dart';

class UnitsSelector extends StatelessWidget {
  final int units;
  final Function(int) onUnitsChanged;

  const UnitsSelector({
    super.key,
    required this.units,
    required this.onUnitsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UnitControlButton(
          onPressed: () {
            if (units > 1) {
              onUnitsChanged(units - 1);
            }
          },
          icon: const Icon(Icons.remove, color: Colors.red),
        ),
        Expanded(
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$units',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        UnitControlButton(
          onPressed: () {
            onUnitsChanged(units + 1);
          },
          icon: const Icon(Icons.add, color: Colors.red),
        ),
      ],
    );
  }
}
