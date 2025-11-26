import 'package:flutter/material.dart';

class ChildActivityCard extends StatelessWidget {
  const ChildActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample activity data
    final List<ActivityItem> activities = [
      ActivityItem(
        title: 'Class Participation',
        icon: Icons.pan_tool,
        count: 12,
        color: Colors.blue,
        subtitle: 'Active in class',
      ),
      ActivityItem(
        title: 'Assignments',
        icon: Icons.assignment,
        count: 8,
        color: Colors.green,
        subtitle: 'Completed this week',
      ),
      ActivityItem(
        title: 'Quizzes',
        icon: Icons.quiz,
        count: 5,
        color: Colors.orange,
        subtitle: 'Taken this month',
      ),
      ActivityItem(
        title: 'Projects',
        icon: Icons.work,
        count: 3,
        color: Colors.purple,
        subtitle: 'In progress',
      ),
    ];

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
                  Icon(Icons.track_changes, color: Colors.purple[700], size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'My Child Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all activities
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.purple[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Activities Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return _buildActivityItem(activities[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: activity.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: activity.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: activity.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  activity.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Text(
                '${activity.count}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: activity.color,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                activity.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final IconData icon;
  final int count;
  final Color color;
  final String subtitle;

  ActivityItem({
    required this.title,
    required this.icon,
    required this.count,
    required this.color,
    required this.subtitle,
  });
}

