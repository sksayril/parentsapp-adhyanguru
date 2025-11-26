import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(),
              
              const SizedBox(height: 24),
              
              // Profile Information Card
              _buildProfileInfoCard(),
              
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
    );
  }

  Widget _buildProfileHeader() {
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
                  child: Container(
                    color: Colors.purple[100],
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.purple[700],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Rownok Ahmed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Parent Account',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('2', 'Children'),
              _buildStatItem('5', 'Active Courses'),
              _buildStatItem('12', 'Activities'),
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
          _buildInfoRow(Icons.email, 'Email', 'rownok.ahmed@example.com'),
          const Divider(height: 32),
          _buildInfoRow(Icons.phone, 'Phone', '+1 234 567 8900'),
          const Divider(height: 32),
          _buildInfoRow(Icons.location_on, 'Address', '123 Main Street, City, State'),
          const Divider(height: 32),
          _buildInfoRow(Icons.calendar_today, 'Member Since', 'January 2024'),
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
        Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
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
      onTap: () {},
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
}

