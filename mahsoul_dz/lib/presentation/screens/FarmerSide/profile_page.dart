import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/farmerSide/farmer_profile_model.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/profile_card.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/stat_card.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/menu_option.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/logout_button.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/edit_farmer_profile_dialog.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_profile_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_dashboard_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_dashboard_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile and dashboard when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated && authState.userType == 'farmer') {
        context.read<FarmerProfileCubit>().loadProfile();
        context.read<FarmerDashboardCubit>().loadDashboardData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? farmerId;
        if (authState is AuthAuthenticated && authState.userType == 'farmer') {
          farmerId = authState.userId;
        }
        
        if (farmerId == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(l10n.pleaseLoginToViewProfile),
            ),
          );
        }
        
        // Provide cubits if not already provided
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FarmerProfileCubit(DependencyInjection.profileRepository, farmerId!)..loadProfile(),
            ),
            BlocProvider(
              create: (context) => FarmerDashboardCubit(DependencyInjection.farmerRepository, farmerId!)..loadDashboardData(),
            ),
          ],
          child: BlocBuilder<FarmerProfileCubit, FarmerProfileState>(
            builder: (context, profileState) {
              return BlocBuilder<FarmerDashboardCubit, FarmerDashboardState>(
                builder: (context, dashboardState) {
                  FarmerProfileModel? profile;
                  int ordersCompleted = 0;
                  double totalEarnings = 0.0;
                  int activeProducts = 0;
                  
                  if (profileState is FarmerProfileLoading || dashboardState is FarmerDashboardLoading) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (profileState is FarmerProfileError) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              profileState.message,
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  if (profileState is FarmerProfileLoaded) {
                    final profileData = profileState.profile;
                    final farmerData = profileData['farmer'] as Map<String, dynamic>?;
                    // Get established year from farmer profile or user created_at
                    final farmerEstablishedYear = farmerData?['established_year'] as String?;
                    String established = l10n.nA;
                    if (farmerEstablishedYear != null && farmerEstablishedYear.isNotEmpty) {
                      established = farmerEstablishedYear;
                    } else {
                      final createdAt = profileData['created_at'] as int?;
                      if (createdAt != null) {
                        established = DateFormat('yyyy').format(DateTime.fromMillisecondsSinceEpoch(createdAt));
                      }
                    }
                    
                    profile = FarmerProfileModel(
                      farmName: farmerData?['farm_name'] as String? ?? '',
                      farmerName: profileData['full_name'] as String? ?? '',
                      profileImageUrl: profileData['profile_image_path'] as String? ?? 'lib/assets/farmerpfp.png',
                      isVerified: farmerData?['is_verified'] == 1 || farmerData?['is_verified'] == true,
                      farmLocation: farmerData?['farm_location'] as String? ?? '',
                      established: established,
                      contactNumber: profileData['phone_number'] as String? ?? '',
                      emailAddress: profileData['email'] as String? ?? '',
                      ordersCompleted: ordersCompleted,
                      totalEarnings: totalEarnings,
                      currency: 'DA',
                      activeProducts: activeProducts,
                    );
                  }
                  
                  if (dashboardState is FarmerDashboardLoaded) {
                    final dashboard = dashboardState.data;
                    // Backend returns statistics under 'statistics' key
                    final statistics = dashboard['statistics'] as Map<String, dynamic>? ?? {};
                    ordersCompleted = statistics['orders_completed'] as int? ?? 0;
                    totalEarnings = (statistics['total_earnings'] as num?)?.toDouble() ?? 0.0;
                    activeProducts = statistics['active_products'] as int? ?? 0;
                    
                    if (profile != null) {
                      profile = profile.copyWith(
                        ordersCompleted: ordersCompleted,
                        totalEarnings: totalEarnings,
                        activeProducts: activeProducts,
                      );
                    }
                  }
                  
                  if (profile == null) {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(child: Text(l10n.noProfileDataAvailable)),
                    );
                  }
                  
                  return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.appName,
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
                              profile: profile,
                              onEditProfile: () {
                                // Get current profile data
                                final profileData = profileState is FarmerProfileLoaded 
                                    ? profileState.profile 
                                    : <String, dynamic>{};
                                final farmerData = profileData['farmer'] as Map<String, dynamic>?;
                                
                                // Show edit profile dialog
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => BlocProvider.value(
                                    value: context.read<FarmerProfileCubit>(),
                                    child: EditFarmerProfileDialog(
                                      currentProfile: profileData,
                                      farmerData: farmerData,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            // Farm Overview Section
                            _buildSectionTitle(l10n.farmOverview),
                            const SizedBox(height: 12),
                            
                            // Orders Completed Card
                            StatCard(
                              svgPath: 'lib/assets/farmeroverview_1.svg',
                              iconColor: Color(0xFF1E3A8A),
                              backgroundColor: Color(0xFFBAE6FD),
                              title: l10n.ordersCompleted,
                              value: profile.ordersCompleted.toString(),
                            ),
                            const SizedBox(height: 12),
                            
                            // Total Earnings Card
                            StatCard(
                              svgPath: 'lib/assets/farmeroverview_2.svg',
                              iconColor: Color(0xFFCA8A04),
                              backgroundColor: Color(0xFFFEF08A),
                              title: l10n.totalEarnings,
                              value: '${profile.totalEarnings.toStringAsFixed(0)} ${profile.currency}',
                            ),
                            const SizedBox(height: 12),
                            
                            // Active Products Card
                            StatCard(
                              svgPath: 'lib/assets/farmeroverview_3.svg',
                              iconColor: Color(0xFF15803D),
                              backgroundColor: Color(0xFFBBF7D0),
                              title: l10n.activeProducts,
                              value: profile.activeProducts.toString(),
                            ),
                            const SizedBox(height: 24),
                            
                            // Contact Support Option
                            MenuOptionSvg(
                              svgPath: 'lib/assets/call-svg.svg',
                              title: l10n.contactSupport,
                              subtitle: l10n.getHelpOrReportIssue,
                              onTap: () {
                                // TODO: Implement contact support with Cubit
                              },
                            ),
                            const SizedBox(height: 12),
                            
                            // Settings Option
                            MenuOption(
                              icon: Icons.settings,
                              title: l10n.settings,
                              subtitle: l10n.viewGeneralSettings,
                              onTap: () {
                                // TODO: Implement settings with Cubit
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Logout Button
                            LogoutButton(
                              onTap: () {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text(
                                      l10n.logout,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      l10n.areYouSureLogout,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dialogContext),
                                        child: Text(
                                          l10n.cancel,
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          // Logout and navigate to login page
                                          context.read<AuthCubit>().logout();
                                          // Navigate to user mode screen
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                            '/home',
                                            (route) => false,
                                          );
                                        },
                                        child: Text(
                                          l10n.logout,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
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