import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/activities_model.dart';
import '../widgets/skeleton_loader.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ActivitiesResponse? _activitiesData;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  
  int _currentPage = 1;
  final int _limit = 20;
  String? _selectedEventType;
  String? _selectedCourseId;
  String? _selectedBatchId;
  
  final ScrollController _scrollController = ScrollController();
  final List<ActivityItem> _allActivities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoadingMore &&
          _activitiesData != null &&
          _activitiesData!.pagination.hasNextPage) {
        _loadMoreActivities();
      }
    }
  }

  Future<void> _loadActivities({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _allActivities.clear();
      });
    }

    setState(() {
      _isLoading = _currentPage == 1;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.getAllChildrenActivities(
        limit: _limit,
        page: _currentPage,
        eventType: _selectedEventType,
        courseId: _selectedCourseId,
        batchId: _selectedBatchId,
      );

      if (result['success'] == true && result['data'] != null) {
        final activitiesResponse = ActivitiesResponse.fromJson(result['data']);
        setState(() {
          if (_currentPage == 1) {
            _activitiesData = activitiesResponse;
            _allActivities.clear();
            _allActivities.addAll(activitiesResponse.activities);
          } else {
            _allActivities.addAll(activitiesResponse.activities);
            _activitiesData = ActivitiesResponse(
              children: _activitiesData!.children,
              activities: _allActivities,
              activitiesByStudent: _activitiesData!.activitiesByStudent,
              pagination: activitiesResponse.pagination,
              filters: _activitiesData!.filters,
            );
          }
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load activities';
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMoreActivities() async {
    if (_isLoadingMore || !_activitiesData!.pagination.hasNextPage) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await _loadActivities();
  }

  void _onFilterChanged() {
    _loadActivities(refresh: true);
  }

  String _formatTimeAgo(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'quiz':
        return Icons.quiz;
      case 'assignment':
        return Icons.assignment;
      case 'view':
        return Icons.visibility;
      case 'attendance':
        return Icons.person;
      case 'login':
        return Icons.login;
      default:
        return Icons.event;
    }
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'quiz':
        return Colors.green;
      case 'assignment':
        return Colors.blue;
      case 'view':
        return Colors.purple;
      case 'attendance':
        return Colors.orange;
      case 'login':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _isLoading && _currentPage == 1
            ? const DashboardSkeletonLoader()
            : _errorMessage != null && _allActivities.isEmpty
                ? _buildErrorView()
                : Column(
                    children: [
                      // Header
                      _buildHeader(),
                      
                      // Filters
                      _buildFilters(),
                      
                      // Activity Feed
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => _loadActivities(refresh: true),
                          color: Colors.purple,
                          child: _activitiesData == null || _allActivities.isEmpty
                              ? _buildEmptyView()
                              : ListView(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  children: [
                                    // Summary
                                    if (_activitiesData!.activitiesByStudent.isNotEmpty)
                                      _buildSummary(),
                                    if (_activitiesData!.activitiesByStudent.isNotEmpty)
                                      const SizedBox(height: 16),
                                    
                                    // Activities List
                                    _buildActivitiesList(),
                                    
                                    // Load More Indicator
                                    if (_isLoadingMore)
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                                          ),
                                        ),
                                      ),
                                    
                                    // Pagination Info
                                    if (_activitiesData!.pagination.hasNextPage == false &&
                                        _allActivities.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'No more activities',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
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
                'Track your children\'s activities',
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

  Widget _buildFilters() {
    final eventTypes = ['All', 'quiz', 'assignment', 'view', 'attendance', 'login'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Type:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: eventTypes.length,
              itemBuilder: (context, index) {
                final eventType = eventTypes[index];
                final isSelected = eventType == 'All'
                    ? _selectedEventType == null
                    : _selectedEventType == eventType;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(eventType),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedEventType = eventType == 'All' ? null : eventType;
                      });
                      _onFilterChanged();
                    },
                    selectedColor: Colors.purple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 12,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final summary = _activitiesData!.activitiesByStudent;
    final totalActivities = summary.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );

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
            'Activity Summary',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                totalActivities.toString(),
                'Total Activities',
                Icons.event_note,
              ),
              _buildSummaryItem(
                summary.length.toString(),
                'Children',
                Icons.people,
              ),
              _buildSummaryItem(
                _allActivities.length.toString(),
                'This Page',
                Icons.list,
              ),
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActivitiesList() {
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
        ..._allActivities.map((activity) => _buildActivityCard(activity)),
      ],
    );
  }

  Widget _buildActivityCard(ActivityItem activity) {
    final eventColor = _getEventColor(activity.eventType);
    final eventIcon = _getEventIcon(activity.eventType);
    
    String title = activity.eventType.toUpperCase();
    String description = '';
    
    if (activity.lesson != null) {
      title = activity.lesson!.title;
      description = '${activity.course?.title ?? ''} - ${activity.batch?.title ?? ''}';
    } else if (activity.course != null) {
      title = activity.course!.title;
      description = activity.batch?.title ?? '';
    }
    
    // Add score info if available
    if (activity.value != null && activity.value!['score'] != null) {
      final score = activity.value!['score'];
      final maxScore = activity.value!['maxScore'] ?? 100;
      description += ' | Score: $score/$maxScore';
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: eventColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  eventIcon,
                  color: eventColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Name
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.purple[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity.student.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${activity.student.studentId})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Tags and Time
                    Row(
                      children: [
                        if (activity.tags.isNotEmpty) ...[
                          ...activity.tags.take(2).map((tag) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              )),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimeAgo(activity.createdAt),
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
              // Event Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: eventColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: eventColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  activity.eventType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: eventColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () => _loadActivities(refresh: true),
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

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No activities found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
