import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Today', 'This Week', 'This Month'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Filter Chips
            _buildFilterChips(),
            
            // Activity Feed
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Summary
                    _buildTodaySummary(),
                    const SizedBox(height: 16),
                    
                    // Activity Timeline
                    _buildActivityTimeline(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track your child\'s activities',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search,
              color: Colors.purple[700],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: Colors.purple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodaySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple[400]!,
            Colors.purple[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Activity',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('8', 'Completed', Icons.check_circle),
              _buildSummaryItem('3', 'In Progress', Icons.hourglass_empty),
              _buildSummaryItem('2', 'Pending', Icons.schedule),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTimeline() {
    final List<ActivityItem> activities = [
      ActivityItem(
        title: 'Mathematics Assignment',
        description: 'Completed Chapter 5 exercises',
        time: '2 hours ago',
        type: ActivityType.assignment,
        status: ActivityStatus.completed,
        icon: Icons.assignment,
        color: Colors.blue,
      ),
      ActivityItem(
        title: 'Science Quiz',
        description: 'Scored 92% on Biology quiz',
        time: '4 hours ago',
        type: ActivityType.quiz,
        status: ActivityStatus.completed,
        icon: Icons.quiz,
        color: Colors.green,
      ),
      ActivityItem(
        title: 'English Project',
        description: 'Working on essay about literature',
        time: '6 hours ago',
        type: ActivityType.project,
        status: ActivityStatus.inProgress,
        icon: Icons.work,
        color: Colors.orange,
      ),
      ActivityItem(
        title: 'Class Participation',
        description: 'Active participation in History class',
        time: '1 day ago',
        type: ActivityType.participation,
        status: ActivityStatus.completed,
        icon: Icons.pan_tool,
        color: Colors.purple,
      ),
      ActivityItem(
        title: 'Art Project',
        description: 'Submitted painting assignment',
        time: '1 day ago',
        type: ActivityType.project,
        status: ActivityStatus.completed,
        icon: Icons.palette,
        color: Colors.pink,
      ),
      ActivityItem(
        title: 'Mathematics Quiz',
        description: 'Upcoming quiz scheduled',
        time: '2 days ago',
        type: ActivityType.quiz,
        status: ActivityStatus.pending,
        icon: Icons.quiz,
        color: Colors.amber,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...activities.map((activity) => _buildActivityCard(activity)),
      ],
    );
  }

  Widget _buildActivityCard(ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with status indicator
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: activity.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  activity.icon,
                  color: activity.color,
                  size: 24,
                ),
              ),
              if (activity.status == ActivityStatus.completed)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _buildStatusBadge(activity.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activity.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ActivityStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ActivityStatus.completed:
        color = Colors.green;
        text = 'Done';
        icon = Icons.check_circle;
        break;
      case ActivityStatus.inProgress:
        color = Colors.orange;
        text = 'Active';
        icon = Icons.hourglass_empty;
        break;
      case ActivityStatus.pending:
        color = Colors.amber;
        text = 'Pending';
        icon = Icons.schedule;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String description;
  final String time;
  final ActivityType type;
  final ActivityStatus status;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.status,
    required this.icon,
    required this.color,
  });
}

enum ActivityType {
  assignment,
  quiz,
  project,
  participation,
}

enum ActivityStatus {
  completed,
  inProgress,
  pending,
}

