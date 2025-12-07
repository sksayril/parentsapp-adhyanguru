import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/profile_model.dart';
import '../widgets/skeleton_loader.dart';
import '../utils/session_manager.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileResponse? _profileData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.getParentProfile();

      if (result['success'] == true && result['data'] != null) {
        setState(() {
          _profileData = ProfileResponse.fromJson(result['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load profile';
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

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _isLoading
            ? const DashboardSkeletonLoader()
            : _errorMessage != null && _profileData == null
                ? _buildErrorView()
                : RefreshIndicator(
                    onRefresh: _loadProfile,
                    color: Colors.purple,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Profile Header
                          _buildProfileHeader(),
                          
                          const SizedBox(height: 24),
                          
                          // Profile Information Card
                          _buildProfileInfoCard(),
                          
                          const SizedBox(height: 16),
                          
                          // Children Section
                          if (_profileData != null && _profileData!.children.isNotEmpty)
                            _buildChildrenSection(),
                          
                          if (_profileData != null && _profileData!.children.isNotEmpty)
                            const SizedBox(height: 16),
                          
                          // Settings Section
                          _buildSettingsSection(),
                          
                          const SizedBox(height: 16),
                          
                          // Account Section
                          _buildAccountSection(),
                          
                          const SizedBox(height: 16),
                          
                          // Support Section
                          _buildSupportSection(),
                          
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_profileData == null) return const SizedBox.shrink();
    
    final parent = _profileData!.parent;
    final summary = _profileData!.summary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: parent.profileImage != null && parent.profileImage!.isNotEmpty
                      ? Image.network(
                          parent.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.purple[100],
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.purple[700],
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.purple[100],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.purple[700],
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            parent.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Parent Account',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                summary.totalChildren.toString(),
                'Children',
              ),
              _buildStatItem(
                summary.activeEnrollments.toString(),
                'Active Courses',
              ),
              _buildStatItem(
                summary.activeSubscriptions.toString(),
                'Subscriptions',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard() {
    if (_profileData == null) return const SizedBox.shrink();
    
    final parent = _profileData!.parent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.email, 'Email', parent.email),
          const Divider(height: 32),
          _buildInfoRow(Icons.phone, 'Phone', parent.contactNumber),
          if (parent.studentId != null) ...[
            const Divider(height: 32),
            _buildInfoRow(Icons.school, 'Student ID', parent.studentId!),
          ],
          const Divider(height: 32),
          _buildInfoRow(
            Icons.calendar_today,
            'Member Since',
            _formatDate(parent.createdAt),
          ),
          if (parent.lastLogin != null) ...[
            const Divider(height: 32),
            _buildInfoRow(
              Icons.access_time,
              'Last Login',
              _formatDate(parent.lastLogin),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.purple[700], size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenSection() {
    if (_profileData == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'My Children',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ..._profileData!.children.map((child) => _buildChildCard(child)),
        ],
      ),
    );
  }

  Widget _buildChildCard(ChildProfileInfo child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Header
          Row(
            children: [
              // Profile Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple[100],
                  border: Border.all(color: Colors.purple[300]!, width: 2),
                ),
                child: ClipOval(
                  child: child.profileImage != null && child.profileImage!.isNotEmpty
                      ? Image.network(
                          child.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Colors.purple[700],
                              size: 30,
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.purple[700],
                          size: 30,
                        ),
                ),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      '${child.studentId} | ${child.classInfo?.name ?? "N/A"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Subscription Badge
              if (child.hasActiveSubscription)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Academic Info
          if (child.board != null || child.studentLevel != null) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (child.board != null)
                  _buildInfoChip(Icons.school, child.board!.name),
                if (child.studentLevel != null)
                  _buildInfoChip(Icons.star, child.studentLevel!.name),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Subscription Info
          if (child.subscriptions.active != null) ...[
            _buildSubscriptionInfo(child.subscriptions.active!),
            const SizedBox(height: 16),
          ],
          
          // Enrollments Summary
          _buildEnrollmentsSummary(child.enrollments),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.purple[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.purple[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionInfo(SubscriptionInfo subscription) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Subscription',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              if (subscription.daysRemaining != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${subscription.daysRemaining} days left',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription.plan?.name ?? subscription.planType.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                ),
              ),
              Text(
                '₹${subscription.finalAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentsSummary(EnrollmentsInfo enrollments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Course Enrollments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '${enrollments.activeCount} Active',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (enrollments.active.isEmpty)
          Text(
            'No active enrollments',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          )
        else
          ...enrollments.active.take(3).map((enrollment) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enrollment.course.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          enrollment.batch.title,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${enrollment.progress.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple[700],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        if (enrollments.active.length > 3)
          TextButton(
            onPressed: () {},
            child: Text(
              'View all ${enrollments.total} enrollments',
              style: TextStyle(
                fontSize: 12,
                color: Colors.purple[700],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(Icons.notifications, 'Notifications', true),
          const Divider(height: 32),
          _buildSettingItem(Icons.language, 'Language', false),
          const Divider(height: 32),
          _buildSettingItem(Icons.dark_mode, 'Dark Mode', false),
          const Divider(height: 32),
          _buildSettingItem(Icons.security, 'Privacy & Security', false),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool hasSwitch) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.purple[700], size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        if (hasSwitch)
          Switch(
            value: true,
            onChanged: (value) {},
            activeColor: Colors.purple,
          )
        else
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildAccountItem(Icons.person_add, 'Add Child Account'),
          const Divider(height: 32),
          _buildAccountItem(Icons.family_restroom, 'Manage Family'),
          const Divider(height: 32),
          _buildAccountItem(Icons.payment, 'Payment Methods'),
          const Divider(height: 32),
          _buildAccountItem(Icons.receipt, 'Billing History'),
        ],
      ),
    );
  }

  Widget _buildAccountItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.purple[700], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSupportItem(Icons.help_outline, 'Help Center'),
          const Divider(height: 32),
          _buildSupportItem(Icons.chat_bubble_outline, 'Contact Support'),
          const Divider(height: 32),
          _buildSupportItem(Icons.info_outline, 'About App'),
          const Divider(height: 32),
          _buildSupportItem(Icons.logout, 'Logout', isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSupportItem(IconData icon, String title, {bool isLogout = false}) {
    return InkWell(
      onTap: isLogout ? _handleLogout : () {},
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLogout ? Colors.red[50] : Colors.purple[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isLogout ? Colors.red[700] : Colors.purple[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.red[700] : Colors.black87,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
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
              onPressed: _loadProfile,
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
}
