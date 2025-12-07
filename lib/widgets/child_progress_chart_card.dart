import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_model.dart';

class ChildProgressChartCard extends StatelessWidget {
  final List<ChildInfo> children;
  final String period;

  const ChildProgressChartCard({
    super.key,
    required this.children,
    this.period = '30d',
  });

  @override
  Widget build(BuildContext context) {
    // Get progress data from children
    final progressData = children
        .where((child) => child.progress != null)
        .map((child) => child.progress!)
        .toList();

    // Calculate average progress for chart (simplified - using completion rate)
    final avgProgress = progressData.isNotEmpty
        ? progressData.map((p) => p.completionRate).reduce((a, b) => a + b) /
            progressData.length
        : 0.0;

    // For chart, we'll use a simplified representation
    // In a real app, you'd want to get historical data
    final List<double> weeklyProgress = List.generate(7, (index) {
      // Simulate weekly data based on average
      return avgProgress + (index % 3 - 1) * 5;
    });

    final avgScore = progressData.isNotEmpty
        ? progressData.map((p) => p.avgScore).reduce((a, b) => a + b) /
            progressData.length
        : 0.0;

    final maxScore = progressData.isNotEmpty
        ? progressData.map((p) => p.maxScore).reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.purple[700], size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'My Child Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  period.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 200,
            child: weeklyProgress.isNotEmpty
                ? LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey[200]!,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < days.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    days[value.toInt()],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: weeklyProgress.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(), entry.value);
                          }).toList(),
                          isCurved: true,
                          color: Colors.purple,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 5,
                                color: Colors.purple,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.purple.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'No progress data available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Summary Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  'Average', '${avgScore.toStringAsFixed(0)}%', Colors.blue),
              _buildStatItem(
                  'Highest', '${maxScore.toStringAsFixed(0)}%', Colors.green),
              _buildStatItem('Completion',
                  '${avgProgress.toStringAsFixed(0)}%', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
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
