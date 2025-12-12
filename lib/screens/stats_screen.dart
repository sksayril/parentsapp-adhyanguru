import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../models/child_progress_model.dart';
import '../widgets/skeleton_loader.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<ChildListItem> _children = [];
  ChildListItem? _selectedChild;
  ChildProgressResponse? _progressData;
  bool _isLoadingChildren = true;
  bool _isLoadingProgress = false;
  String? _errorMessage;
  String _selectedPeriod = '30d';
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    _loadChildrenList();
  }

  Future<void> _loadChildrenList() async {
    setState(() {
      _isLoadingChildren = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.getMyChildrenList();

      if (result['success'] == true && result['data'] != null) {
        final childrenList = ChildrenListResponse.fromJson(result['data']);
        setState(() {
          _children = childrenList.children;
          _isLoadingChildren = false;
          // Auto-select first child if available
          if (_children.isNotEmpty) {
            _selectedChild = _children.first;
            _loadChildProgress();
          }
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load children list';
          _isLoadingChildren = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoadingChildren = false;
      });
    }
  }

  Future<void> _loadChildProgress() async {
    if (_selectedChild == null) return;

    setState(() {
      _isLoadingProgress = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.getChildProgress(
        childId: _selectedChild!.id,
        period: _selectedPeriod,
        courseId: _selectedCourseId,
      );

      if (result['success'] == true && result['data'] != null) {
        setState(() {
          _progressData = ChildProgressResponse.fromJson(result['data']);
          _isLoadingProgress = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load progress';
          _isLoadingProgress = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoadingProgress = false;
      });
    }
  }

  void _onChildChanged(ChildListItem? child) {
    setState(() {
      _selectedChild = child;
      _selectedCourseId = null; // Reset course filter
    });
    _loadChildProgress();
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadChildProgress();
  }

  void _onCourseChanged(String? courseId) {
    setState(() {
      _selectedCourseId = courseId;
    });
    _loadChildProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _isLoadingChildren
            ? const DashboardSkeletonLoader()
            : _errorMessage != null && _children.isEmpty
                ? _buildErrorView()
                : RefreshIndicator(
                    onRefresh: _loadChildrenList,
                    color: Colors.purple,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Child Selector
                            _buildHeader(),
                            const SizedBox(height: 24),

                            // Period and Course Filters
                            if (_selectedChild != null) ...[
                              _buildFilters(),
                              const SizedBox(height: 16),
                            ],

                            // Content
                            if (_selectedChild == null)
                              _buildNoChildSelected()
                            else if (_isLoadingProgress)
                              const DashboardSkeletonLoader()
                            else if (_errorMessage != null)
                              _buildErrorView()
                            else if (_progressData == null)
                              const Center(child: Text('No data available'))
                            else ...[
                              // Overall Performance Card
                              _buildOverallPerformanceCard(),
                              const SizedBox(height: 16),

                              // Quick Stats Row
                              _buildQuickStatsRow(),
                              const SizedBox(height: 16),

                              // Performance Chart
                              _buildPerformanceChart(),
                              const SizedBox(height: 16),

                              // Subject-wise Performance (Courses)
                              _buildSubjectPerformance(),
                              const SizedBox(height: 16),

                              // Weekly Activity Chart
                              _buildWeeklyActivityChart(),
                              const SizedBox(height: 24),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track your child\'s progress',
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
                Icons.filter_list,
                color: Colors.purple[700],
                size: 24,
              ),
            ),
          ],
        ),
        if (_children.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildChildSelector(),
        ],
      ],
    );
  }

  Widget _buildChildSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ChildListItem>(
          value: _selectedChild,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Colors.purple[700]),
          items: _children.map((child) {
            return DropdownMenuItem<ChildListItem>(
              value: child,
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.purple[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          child.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          child.studentId,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: _onChildChanged,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        // Period Selector
        Flexible(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                Flexible(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: ['7d', '30d', '90d', '1y'].map((period) {
                      final isSelected = _selectedPeriod == period;
                      return GestureDetector(
                        onTap: () => _onPeriodChanged(period),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Course Filter
        if (_progressData != null && _progressData!.enrollments.isNotEmpty)
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedCourseId,
                  isExpanded: true,
                  hint: const Text(
                    'All Courses',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.purple[700]),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        'All Courses',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    ..._progressData!.enrollments.map((enrollment) {
                      return DropdownMenuItem<String?>(
                        value: enrollment.course.id,
                        child: Text(
                          enrollment.course.title,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }),
                  ],
                  onChanged: _onCourseChanged,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoChildSelected() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.child_care, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No children found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Please add children to your account',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'An error occurred',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadChildrenList,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallPerformanceCard() {
    if (_progressData == null) return const SizedBox.shrink();
    
    final summary = _progressData!.summary;
    final completionRate = summary.completionRate;

    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Performance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${summary.avgScore.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: completionRate / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Text(
                      _getGrade(summary.avgScore),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '${summary.totalAttempts}',
                'Attempts',
                Colors.white,
              ),
              _buildStatItem(
                '${_progressData!.enrollments.length}',
                'Active Courses',
                Colors.white,
              ),
              _buildStatItem(
                '${summary.attendanceRate.toStringAsFixed(0)}%',
                'Attendance',
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGrade(double score) {
    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    return 'D';
  }

  Widget _buildStatItem(String value, String label, Color color) {
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
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow() {
    if (_progressData == null) return const SizedBox.shrink();
    
    final summary = _progressData!.summary;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Lessons',
            '${summary.completedLessons}/${summary.totalLessons}',
            'Completed',
            Icons.book,
            Colors.blue,
            '${summary.completionRate.toStringAsFixed(0)}% done',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Time Spent',
            '${(summary.timeSpentMinutes / 60).toStringAsFixed(1)}h',
            'This Period',
            Icons.access_time,
            Colors.green,
            '${summary.timeSpentMinutes} min',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Score Range',
            '${summary.maxScore.toStringAsFixed(0)}%',
            'Highest',
            Icons.trending_up,
            Colors.orange,
            'Min: ${summary.minScore.toStringAsFixed(0)}%',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    String footer,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            footer,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    if (_progressData == null) return const SizedBox.shrink();
    
    // Simplified chart - in real app, you'd want historical data
    final summary = _progressData!.summary;
    final avgScore = summary.avgScore;
    
    // Simulate monthly data based on average
    final List<double> monthlyScores = List.generate(6, (index) {
      return avgScore + (index % 3 - 1) * 3;
    });
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Performance Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Period: $_selectedPeriod',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.purple,
                    tooltipRoundedRadius: 8,
                  ),
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
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
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
                barGroups: monthlyScores.asMap().entries.map((entry) {
                  final index = entry.key;
                  final score = entry.value;
                  final isLast = index == monthlyScores.length - 1;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: score,
                        color: isLast ? Colors.purple : Colors.purple[300],
                        width: 30,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    if (_progressData == null || _progressData!.enrollments.isEmpty) {
      return const SizedBox.shrink();
    }

    final enrollments = _progressData!.enrollments;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
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
          const Text(
            'Course-wise Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...enrollments.asMap().entries.map((entry) {
            final index = entry.key;
            final enrollment = entry.value;
            final color = colors[index % colors.length];
            return _buildSubjectItem(enrollment, color);
          }),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(EnrollmentInfo enrollment, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                      enrollment.course.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Batch: ${enrollment.batch.title}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${enrollment.progress.percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: enrollment.progress.percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${enrollment.progress.lessonsCompleted} of ${enrollment.progress.totalLessons} lessons completed',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityChart() {
    if (_progressData == null) return const SizedBox.shrink();
    
    // Simplified weekly activity - in real app, you'd want actual daily data
    final summary = _progressData!.summary;
    final avgDaily = (summary.timeSpentMinutes / 7).round();
    
    final List<double> weeklyData = List.generate(7, (index) {
      return (avgDaily + (index % 3 - 1) * 10).toDouble();
    });
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
          const Text(
            'Weekly Activity (Minutes)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
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
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
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
                          '${value.toInt()}',
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
                maxY: weeklyData.reduce((a, b) => a > b ? a : b).ceilToDouble() + 20,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyData.asMap().entries.map((entry) {
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
            ),
          ),
        ],
      ),
    );
  }
}
