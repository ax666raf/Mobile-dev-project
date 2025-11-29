import 'package:flutter/material.dart';
import 'package:mahsoul_dz/logic/farmer_profile_controller.dart';
import 'package:mahsoul_dz/views/models/farmerSide/farmer_profile_model.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/profile_card.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/stat_card.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/menu_option.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/logout_button.dart';

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
              ProfileCard(
                profile: _profile,
                controller: _controller,
              ),
              const SizedBox(height: 20),
              
              // Farm Overview Section
              _buildSectionTitle('Farm Overview'),
              const SizedBox(height: 12),
              
              // Orders Completed Card
              StatCard(
                svgPath: 'lib/assets/farmeroverview_1.svg',
                iconColor: Color(0xFF1E3A8A),
                backgroundColor: Color(0xFFBAE6FD),
                title: 'Orders Completed',
                value: _profile.ordersCompleted.toString(),
              ),
              const SizedBox(height: 12),
              
              // Total Earnings Card
              StatCard(
                svgPath: 'lib/assets/farmeroverview_2.svg',
                iconColor: Color(0xFFCA8A04),
                backgroundColor: Color(0xFFFEF08A),
                title: 'Total Earnings',
                value: _controller.formatCurrency(
                  _profile.totalEarnings,
                  _profile.currency,
                ),
              ),
              const SizedBox(height: 12),
              
              // Active Products Card
              StatCard(
                svgPath: 'lib/assets/farmeroverview_3.svg',
                iconColor: Color(0xFF15803D),
                backgroundColor: Color(0xFFBBF7D0),
                title: 'Active Products',
                value: _profile.activeProducts.toString(),
              ),
              const SizedBox(height: 24),
              
              // Contact Support Option
              MenuOptionSvg(
                svgPath: 'lib/assets/call-svg.svg',
                title: 'Contact Support',
                subtitle: 'Get help or report an issue',
                onTap: _controller.contactSupport,
              ),
              const SizedBox(height: 12),
              
              // Settings Option
              MenuOption(
                icon: Icons.settings,
                title: 'Settings',
                subtitle: 'View General Settings',
                onTap: _controller.openSettings,
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              LogoutButton(onTap: _controller.logout),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
}