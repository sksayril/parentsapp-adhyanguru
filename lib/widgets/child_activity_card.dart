import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class ChildActivityCard extends StatelessWidget {
  final List<ChildInfo> children;

  const ChildActivityCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // Get all activities from all children
    final allActivities = <ActivityInfo>[];
    for (var child in children) {
      allActivities.addAll(child.activities);
    }

    // Group activities by type and count
    final activityCounts = <String, int>{};
    for (var activity in allActivities) {
      activityCounts[activity.eventType] =
          (activityCounts[activity.eventType] ?? 0) + 1;
    }

    // Create activity items
    final activityItems = <ActivityItem>[];
    activityCounts.forEach((type, count) {
      activityItems.add(_getActivityItem(type, count));
    });

    // If no activities, add placeholder
    if (activityItems.isEmpty) {
      activityItems.addAll([
        ActivityItem(
          title: 'Quizzes',
          icon: Icons.quiz,
          count: 0,
          color: Colors.orange,
          subtitle: 'No quizzes yet',
        ),
        ActivityItem(
          title: 'Assignments',
          icon: Icons.assignment,
          count: 0,
          color: Colors.green,
          subtitle: 'No assignments yet',
        ),
        ActivityItem(
          title: 'Lessons',
          icon: Icons.book,
          count: 0,
          color: Colors.blue,
          subtitle: 'No lessons yet',
        ),
        ActivityItem(
          title: 'Projects',
          icon: Icons.work,
          count: 0,
          color: Colors.purple,
          subtitle: 'No projects yet',
        ),
      ]);
    }

    // Limit to 4 items for grid
    final displayActivities = activityItems.take(4).toList();

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
              if (allActivities.length > 4)
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
            itemCount: displayActivities.length,
            itemBuilder: (context, index) {
              return _buildActivityItem(displayActivities[index]);
            },
          ),
        ],
      ),
    );
  }

  ActivityItem _getActivityItem(String type, int count) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return ActivityItem(
          title: 'Quizzes',
          icon: Icons.quiz,
          count: count,
          color: Colors.orange,
          subtitle: '$count completed',
        );
      case 'assignment':
        return ActivityItem(
          title: 'Assignments',
          icon: Icons.assignment,
          count: count,
          color: Colors.green,
          subtitle: '$count completed',
        );
      case 'lesson':
        return ActivityItem(
          title: 'Lessons',
          icon: Icons.book,
          count: count,
          color: Colors.blue,
          subtitle: '$count viewed',
        );
      case 'project':
        return ActivityItem(
          title: 'Projects',
          icon: Icons.work,
          count: count,
          color: Colors.purple,
          subtitle: '$count in progress',
        );
      default:
        return ActivityItem(
          title: type.toUpperCase(),
          icon: Icons.check_circle,
          count: count,
          color: Colors.grey,
          subtitle: '$count activities',
        );
    }
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
