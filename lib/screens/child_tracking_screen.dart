import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'location_history_screen.dart';

class ChildTrackingScreen extends StatefulWidget {
  const ChildTrackingScreen({super.key});

  @override
  State<ChildTrackingScreen> createState() => _ChildTrackingScreenState();
}

class _ChildTrackingScreenState extends State<ChildTrackingScreen> {
  final MapController _mapController = MapController();
  String? _mapError;
  
  // Sample child locations - in real app, this would come from API
  final List<ChildLocation> _children = [
    ChildLocation(
      id: '1',
      name: 'Sarah',
      latitude: 37.7749,
      longitude: -122.4194,
      lastSeen: '5 min ago',
      batteryLevel: 85,
    ),
    ChildLocation(
      id: '2',
      name: 'John',
      latitude: 37.7849,
      longitude: -122.4094,
      lastSeen: '2 min ago',
      batteryLevel: 92,
    ),
  ];

  final LatLng _initialCenter = const LatLng(37.7749, -122.4194);
  final double _initialZoom = 13.0;

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = _children.map<Marker>((child) {
      return Marker(
        point: LatLng(child.latitude, child.longitude),
        width: 50,
        height: 50,
        child: GestureDetector(
          onTap: () {
            _showChildInfo(child);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                child.name[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showChildInfo(ChildLocation child) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[100],
                  ),
                  child: Center(
                    child: Text(
                      child.name[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Last seen: ${child.lastSeen}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.battery_charging_full,
                      size: 24,
                      color: child.batteryLevel > 50 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${child.batteryLevel}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _focusOnChild(ChildLocation child) {
    final targetLocation = LatLng(child.latitude, child.longitude);
    _mapController.move(targetLocation, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Map View
            Expanded(
              child: Stack(
                children: [
                  _mapError != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Map Error',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  _mapError!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _mapError = null;
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _initialCenter,
                            initialZoom: _initialZoom,
                            minZoom: 3.0,
                            maxZoom: 18.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.parentsapp_adhyanguru',
                              maxZoom: 19,
                            ),
                            MarkerLayer(
                              markers: _markers,
                            ),
                          ],
                        ),
                  
                  // Map Controls
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'zoom_in',
                          onPressed: () {
                            final currentZoom = _mapController.camera.zoom;
                            final newZoom = (currentZoom + 1).clamp(3.0, 18.0);
                            _mapController.move(_mapController.camera.center, newZoom);
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'zoom_out',
                          onPressed: () {
                            final currentZoom = _mapController.camera.zoom;
                            final newZoom = (currentZoom - 1).clamp(3.0, 18.0);
                            _mapController.move(_mapController.camera.center, newZoom);
                          },
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'my_location',
                          onPressed: () {
                            _mapController.move(_initialCenter, _initialZoom);
                          },
                          child: const Icon(Icons.my_location),
                        ),
                      ],
                    ),
                  ),
                  
                  // Child List Overlay - Expandable
                  Positioned.fill(
                    child: _buildExpandableChildList(),
                  ),
                ],
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
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track My Child',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Real-time location tracking',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to location history screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationHistoryScreen(),
                ),
              );
            },
            tooltip: 'Location History',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh locations
              setState(() {
                _createMarkers();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Open settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableChildList() {
    return DraggableScrollableSheet(
      initialChildSize: 0.25, // 25% of screen height initially
      minChildSize: 0.15, // Minimum 15% of screen height
      maxChildSize: 0.85, // Maximum 85% of screen height
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'My Children',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_children.length} Active',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Children List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _children.length,
                  itemBuilder: (context, index) {
                    final child = _children[index];
                    return _buildChildCard(child);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChildCard(ChildLocation child) {
    return GestureDetector(
      onTap: () {
        // Focus on child location on map
        _focusOnChild(child);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple[100],
              ),
              child: Center(
                child: Text(
                  child.name[0],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Child Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        child.lastSeen,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Battery Indicator
            Column(
              children: [
                Icon(
                  Icons.battery_charging_full,
                  size: 20,
                  color: child.batteryLevel > 50 ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 4),
                Text(
                  '${child.batteryLevel}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Navigate Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class ChildLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String lastSeen;
  final int batteryLevel;

  ChildLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lastSeen,
    required this.batteryLevel,
  });
}
