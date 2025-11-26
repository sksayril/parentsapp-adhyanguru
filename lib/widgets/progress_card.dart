import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressCard extends StatelessWidget {
  final double progress;
  final int calories;
  final String date;

  const ProgressCard({
    super.key,
    this.progress = 0.95,
    this.calories = 1350,
    this.date = '19 November',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5FF), // Light purple
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Left side - Text and percentage
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.show_chart, color: Colors.grey[700], size: 24),
                const SizedBox(height: 8),
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[700], size: 20),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Right side - Circular progress
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                // Progress circle
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Transform.rotate(
                    angle: -math.pi / 2,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                    ),
                  ),
                ),
                // Calories text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$calories',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      'Calories',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Flame icon at progress end
                Positioned(
                  child: Transform.translate(
                    offset: Offset(
                      math.cos((progress * 2 * math.pi) - (math.pi / 2)) * 50,
                      math.sin((progress * 2 * math.pi) - (math.pi / 2)) * 50,
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

