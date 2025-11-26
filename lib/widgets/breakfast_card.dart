import 'package:flutter/material.dart';

class BreakfastCard extends StatelessWidget {
  const BreakfastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5), // Light pink
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.show_chart, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Breakfast',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 8),
                  Icon(Icons.edit_outlined, color: Colors.grey[700], size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '350 calories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutritionItem('Proteins', '62.5'),
              _buildNutritionItem('Fats', '23.6'),
              _buildNutritionItem('Carbs', '45.7'),
              _buildNutritionItem('RDC', '14%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

