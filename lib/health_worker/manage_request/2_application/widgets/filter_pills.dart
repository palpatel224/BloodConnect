import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:flutter/material.dart';

class FilterPills extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterPills({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: RequestStatus.values.map((status) {
          final statusString = status.toString().split('.').last;
          final isSelected = statusString == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(statusString),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterSelected(statusString);
                }
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
