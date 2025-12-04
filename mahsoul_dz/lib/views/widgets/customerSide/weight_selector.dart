import 'package:flutter/material.dart';

/// Displays available weight options as selectable buttons
class WeightSelector extends StatelessWidget {
  final String selectedWeight;
  final List<String> weights;
  final Function(String) onWeightSelected;

  const WeightSelector({
    super.key,
    required this.selectedWeight,
    required this.weights,
    required this.onWeightSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Weights',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: weights.map((weight) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _weightButton(weight),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _weightButton(String weight) {
    final isSelected = selectedWeight == weight;
    return GestureDetector(
      onTap: () => onWeightSelected(weight),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            weight,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
