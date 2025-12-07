import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/child_progress_chart_card.dart';
import '../widgets/child_courses_card.dart';
import '../widgets/child_activity_card.dart';
import '../widgets/ai_counseling_card.dart';
import '../widgets/skeleton_loader.dart';
import '../services/api_service.dart';
import '../models/dashboard_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DashboardModel? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedPeriod = '30d';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.getDashboard(period: _selectedPeriod);

      if (result['success'] == true && result['data'] != null) {
        setState(() {
          _dashboardData = DashboardModel.fromJson(result['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load dashboard';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _isLoading
            ? const DashboardSkeletonLoader()
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadDashboard,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : _dashboardData == null
                    ? const Center(
                        child: Text('No data available'),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDashboard,
                        color: Colors.purple,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Section
                                HeaderWidget(
                                  parentName: _dashboardData!.parent.name,
                                  profileImage: _dashboardData!.parent.profileImage,
                                ),
                                const SizedBox(height: 24),

                                // Period Selector
                                _buildPeriodSelector(),
                                const SizedBox(height: 16),

                                // Overall Stats Cards
                                if (_dashboardData!.children.isNotEmpty)
                                  _buildOverallStatsCards(),
                                const SizedBox(height: 16),

                                // 1. My Child Progress Chart Card (First)
                                if (_dashboardData!.children.isNotEmpty)
                                  ChildProgressChartCard(
                                    children: _dashboardData!.children,
                                    period: _selectedPeriod,
                                  ),
                                if (_dashboardData!.children.isNotEmpty)
                                  const SizedBox(height: 16),

                                // 2. My Child Courses Card (Second)
                                if (_dashboardData!.children.isNotEmpty)
                                  ChildCoursesCard(
                                    children: _dashboardData!.children,
                                  ),
                                if (_dashboardData!.children.isNotEmpty)
                                  const SizedBox(height: 16),

                                // 3. My Child Activity Card (Third)
                                if (_dashboardData!.children.isNotEmpty)
                                  ChildActivityCard(
                                    children: _dashboardData!.children,
                                  ),
                                if (_dashboardData!.children.isNotEmpty)
                                  const SizedBox(height: 16),

                                // 4. AI Counseling Card
                                const AICounselingCard(),
                                const SizedBox(height: 24),

                                const SizedBox(height: 80), // Space for bottom nav
                              ],
                            ),
                          ),
                        ),
                      ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Period: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          ...['7d', '30d', '90d', '1y'].map((period) {
            final isSelected = _selectedPeriod == period;
            return GestureDetector(
              onTap: () => _onPeriodChanged(period),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOverallStatsCards() {
    final stats = _dashboardData!.overallStats;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Children',
            stats.totalChildren.toString(),
            Icons.people,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Courses',
            stats.totalActiveCourses.toString(),
            Icons.book,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Score',
            '${stats.overallAvgScore.toStringAsFixed(0)}%',
            Icons.trending_up,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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
      ),
    );
  }
}
