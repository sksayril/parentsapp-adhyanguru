import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/child_tracking_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/activity_screen.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<AnimationController> _animationControllers;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StatsScreen(), // Stats screen
    const ActivityScreen(), // Activity screen
    const ChildTrackingScreen(), // Connect/Tracking screen
    const ProfileScreen(), // Profile screen
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.bar_chart,
    Icons.directions_run,
    Icons.wifi,
    Icons.person,
  ];

  final List<String> _labels = [
    'Home',
    'Stats',
    'Activity',
    'Track',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      _icons.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    // Animate the tap
    _animationControllers[index].forward().then((_) {
      _animationControllers[index].reverse();
    });

    // Update state - IndexedStack will instantly switch to the selected page
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _icons.length,
              (index) => _buildNavItem(_icons[index], _labels[index], index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animationControllers[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_animationControllers[index].value * 0.2),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.purple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.purple.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          icon,
                          key: ValueKey('$icon-$isActive'),
                          color: isActive ? Colors.white : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isActive ? 11 : 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? Colors.purple : Colors.grey[600],
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
