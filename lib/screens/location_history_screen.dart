import 'package:flutter/material.dart';

class LocationHistoryScreen extends StatefulWidget {
  const LocationHistoryScreen({super.key});

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  String? _selectedChild;
  
  // Sample location history data
  final Map<String, List<LocationHistoryEntry>> _locationHistory = {
    'Sarah': [
      LocationHistoryEntry(
        date: DateTime(2024, 1, 15),
        locations: [
          LocationData(
            time: '08:30 AM',
            address: 'School - Main Entrance',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
          LocationData(
            time: '12:00 PM',
            address: 'School - Cafeteria',
            latitude: 37.7750,
            longitude: -122.4195,
          ),
          LocationData(
            time: '03:30 PM',
            address: 'Home - Front Door',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
        ],
      ),
      LocationHistoryEntry(
        date: DateTime(2024, 1, 14),
        locations: [
          LocationData(
            time: '08:25 AM',
            address: 'School - Main Entrance',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
          LocationData(
            time: '02:00 PM',
            address: 'Library - Study Area',
            latitude: 37.7755,
            longitude: -122.4200,
          ),
          LocationData(
            time: '04:00 PM',
            address: 'Home - Front Door',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
        ],
      ),
      LocationHistoryEntry(
        date: DateTime(2024, 1, 13),
        locations: [
          LocationData(
            time: '08:35 AM',
            address: 'School - Main Entrance',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
          LocationData(
            time: '01:30 PM',
            address: 'Park - Playground',
            latitude: 37.7760,
            longitude: -122.4205,
          ),
          LocationData(
            time: '05:00 PM',
            address: 'Home - Front Door',
            latitude: 37.7749,
            longitude: -122.4194,
          ),
        ],
      ),
    ],
    'John': [
      LocationHistoryEntry(
        date: DateTime(2024, 1, 15),
        locations: [
          LocationData(
            time: '08:20 AM',
            address: 'School - Main Entrance',
            latitude: 37.7849,
            longitude: -122.4094,
          ),
          LocationData(
            time: '11:45 AM',
            address: 'School - Gymnasium',
            latitude: 37.7850,
            longitude: -122.4095,
          ),
          LocationData(
            time: '03:45 PM',
            address: 'Home - Front Door',
            latitude: 37.7849,
            longitude: -122.4094,
          ),
        ],
      ),
      LocationHistoryEntry(
        date: DateTime(2024, 1, 14),
        locations: [
          LocationData(
            time: '08:15 AM',
            address: 'School - Main Entrance',
            latitude: 37.7849,
            longitude: -122.4094,
          ),
          LocationData(
            time: '12:30 PM',
            address: 'School - Library',
            latitude: 37.7855,
            longitude: -122.4100,
          ),
          LocationData(
            time: '04:15 PM',
            address: 'Home - Front Door',
            latitude: 37.7849,
            longitude: -122.4094,
          ),
        ],
      ),
    ],
  };

  List<String> get _childrenNames => _locationHistory.keys.toList();

  List<LocationHistoryEntry> get _filteredHistory {
    if (_selectedChild == null) {
      // Show all children's history
      final allEntries = <LocationHistoryEntry>[];
      for (var childHistory in _locationHistory.values) {
        allEntries.addAll(childHistory);
      }
      // Sort by date (newest first)
      allEntries.sort((a, b) => b.date.compareTo(a.date));
      return allEntries;
    } else {
      return _locationHistory[_selectedChild] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Premium App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.purple,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
              title: const Text(
                'Location History',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple[600]!,
                      Colors.purple[400]!,
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Filter Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.purple[700],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Filter by Child',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildPremiumFilterChip('All', null),
                      ..._childrenNames.map((name) => _buildPremiumFilterChip(name, name)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // History List
          _filteredHistory.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = _filteredHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: _buildPremiumDateSection(entry),
                      );
                    },
                    childCount: _filteredHistory.length,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildPremiumFilterChip(String label, String? value) {
    final isSelected = _selectedChild == value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedChild = isSelected ? null : value;
            });
          },
          borderRadius: BorderRadius.circular(25),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Colors.purple[600]!,
                        Colors.purple[400]!,
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
              border: isSelected
                  ? null
                  : Border.all(
                      color: Colors.grey[300]!,
                      width: 1.5,
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 18,
                  )
                else
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumDateSection(LocationHistoryEntry entry) {
    final dateStr = _formatDate(entry.date);
    final childName = _getChildNameForEntry(entry);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Date Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[50]!,
                  Colors.purple[100]!.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (entry.locations.isNotEmpty)
                          Text(
                            '${entry.locations.length} locations',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.purple[700]!.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (childName != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple[600]!,
                          Colors.purple[400]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          childName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Premium Locations List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: entry.locations.asMap().entries.map((locationEntry) {
                final index = locationEntry.key;
                final location = locationEntry.value;
                final isLast = index == entry.locations.length - 1;
                
                return _buildPremiumLocationItem(location, isLast);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumLocationItem(LocationData location, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Timeline indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple[400]!,
                      Colors.purple[600]!,
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purple[300]!,
                        Colors.purple[100]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          
          // Location details with premium card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.purple[700],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        location.time,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    location.address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Premium Map button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple[400]!,
                  Colors.purple[600]!,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to map view with this location
                },
                borderRadius: BorderRadius.circular(14),
                child: const Icon(
                  Icons.map,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 64,
              color: Colors.purple[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No location history found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Location history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String? _getChildNameForEntry(LocationHistoryEntry historyEntry) {
    if (_selectedChild != null) {
      return _selectedChild;
    }
    
    // Find which child this entry belongs to
    for (var childEntry in _locationHistory.entries) {
      if (childEntry.value.contains(historyEntry)) {
        return childEntry.key;
      }
    }
    return null;
  }
}

class LocationHistoryEntry {
  final DateTime date;
  final List<LocationData> locations;

  LocationHistoryEntry({
    required this.date,
    required this.locations,
  });
}

class LocationData {
  final String time;
  final String address;
  final double latitude;
  final double longitude;

  LocationData({
    required this.time,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
