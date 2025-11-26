import 'package:flutter/material.dart';

class ChildCoursesCard extends StatelessWidget {
  const ChildCoursesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample courses data
    final List<CourseItem> courses = [
      CourseItem(
        title: 'Mathematics',
        progress: 0.75,
        instructor: 'Mr. Sharma',
        color: Colors.blue,
      ),
      CourseItem(
        title: 'Science',
        progress: 0.60,
        instructor: 'Ms. Patel',
        color: Colors.green,
      ),
      CourseItem(
        title: 'English',
        progress: 0.85,
        instructor: 'Mr. Kumar',
        color: Colors.orange,
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
                  Icon(Icons.school, color: Colors.purple[700], size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'My Child Courses',
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
                  // Navigate to all courses
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
          
          // Courses List
          ...courses.map((course) => _buildCourseItem(course)).toList(),
        ],
      ),
    );
  }

  Widget _buildCourseItem(CourseItem course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: course.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: course.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.instructor,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: course.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(course.color),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(course.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: course.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CourseItem {
  final String title;
  final double progress;
  final String instructor;
  final Color color;

  CourseItem({
    required this.title,
    required this.progress,
    required this.instructor,
    required this.color,
  });
}

