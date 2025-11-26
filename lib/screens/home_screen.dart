import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/child_progress_chart_card.dart';
import '../widgets/child_courses_card.dart';
import '../widgets/child_activity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const HeaderWidget(),
                const SizedBox(height: 24),
                
                // 1. My Child Progress Chart Card (First)
                const ChildProgressChartCard(),
                const SizedBox(height: 16),
                
                // 2. My Child Courses Card (Second)
                const ChildCoursesCard(),
                const SizedBox(height: 16),
                
                // 3. My Child Activity Card (Third)
                const ChildActivityCard(),
                const SizedBox(height: 24),
                
                const SizedBox(height: 80), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }
}
