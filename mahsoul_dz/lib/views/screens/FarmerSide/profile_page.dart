import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahsoul_dz/logic/farmer_profile_controller.dart';
import 'package:mahsoul_dz/views/models/farmerSide/farmer_profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FarmerProfileController _controller = FarmerProfileController();
  late FarmerProfileModel _profile;

  @override
  void initState() {
    super.initState();
    _profile = _controller.getFarmerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mahsoul',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.eco,
              color: Colors.green,
              size: 24,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Card
              _buildProfileCard(),
              const SizedBox(height: 20),
              
              // Farm Overview Section
              _buildSectionTitle('Farm Overview'),
              const SizedBox(height: 12),
              
              // Orders Completed Card
              _buildStatCard(
                svgPath: 'lib/assets/farmeroverview_1.svg',
                iconColor: Colors.blue.shade700,
                backgroundColor: Colors.blue.shade100,
                title: 'Orders Completed',
                value: _profile.ordersCompleted.toString(),
              ),
              const SizedBox(height: 12),
              
              // Total Earnings Card
              _buildStatCard(
                svgPath: 'lib/assets/farmeroverview_2.svg',
                iconColor: Colors.amber.shade800,
                backgroundColor: Colors.amber.shade100,
                title: 'Total Earnings',
                value: _controller.formatCurrency(
                  _profile.totalEarnings,
                  _profile.currency,
                ),
              ),
              const SizedBox(height: 12),
              
              // Active Products Card
              _buildStatCard(
                svgPath: 'lib/assets/farmeroverview_3.svg',
                iconColor: Colors.green.shade700,
                backgroundColor: Colors.green.shade100,
                title: 'Active Products',
                value: _profile.activeProducts.toString(),
              ),
              const SizedBox(height: 24),
              
              // Contact Support Option
              _buildMenuOption(
                icon: Icons.headset_mic,
                title: 'Contact Support',
                subtitle: 'Get help or report an issue',
                onTap: _controller.contactSupport,
              ),
              const SizedBox(height: 12),
              
              // Settings Option
              _buildMenuOption(
                icon: Icons.settings,
                title: 'Settings',
                subtitle: 'View General Settings',
                onTap: _controller.openSettings,
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              _buildLogoutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image with Verification Badge
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                  image: DecorationImage(
                    image: AssetImage('lib/assets/farmer_placeholder.png'),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                  color: Colors.grey.shade200,
                ),
                child: _profile.profileImageUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade400,
                      )
                    : null,
              ),
              if (_profile.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Farm Name
          Text(
            _profile.farmName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          
          // Verified Farmer Badge
          if (_profile.isVerified)
            Text(
              'Verified Farmer',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 20),
          
          // Edit Profile Button
          Center(
            child: SizedBox(
              width: 140,
              height: 40,
              child: ElevatedButton(
                onPressed: _controller.editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Profile Information
          _buildProfileInfo('Farm Location:', _profile.farmLocation),
          const SizedBox(height: 12),
          _buildProfileInfo('Established:', _profile.established),
          const SizedBox(height: 12),
          _buildProfileInfo('Contact Number:', _profile.contactNumber),
          const SizedBox(height: 12),
          _buildProfileInfo('Email Address:', _profile.emailAddress),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String svgPath,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              svgPath,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.black87,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: InkWell(
        onTap: _controller.logout,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: Colors.red.shade600,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}