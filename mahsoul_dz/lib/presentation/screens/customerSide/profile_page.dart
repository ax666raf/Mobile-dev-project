import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/main.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/serviceTile.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/my_orders_page.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/delivery_address_dialog.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/edit_profile_dialog.dart';
import 'package:mahsoul_dz/data/models/customerSide/customer_profile_model.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/profile_header.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
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
    // Load profile when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated && authState.userType == 'customer') {
        context.read<CustomerProfileCubit>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? customerId;
        if (authState is AuthAuthenticated && authState.userType == 'customer') {
          customerId = authState.userId;
        }
        
        if (customerId == null) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Text(l10n.pleaseLoginToViewProfile),
            ),
          );
        }
        
        return BlocProvider(
          create: (context) => CustomerProfileCubit(DependencyInjection.profileRepository, customerId!)..loadProfile(),
          child: BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
            builder: (context, profileState) {
              CustomerProfileModel? profile;
              
              if (profileState is CustomerProfileLoading) {
                return Scaffold(
                  backgroundColor: Colors.grey[200],
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (profileState is CustomerProfileError) {
                return Scaffold(
                  backgroundColor: Colors.grey[200],
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
              
              if (profileState is CustomerProfileLoaded) {
                final profileData = profileState.profile;
                final createdAt = profileData['created_at'] as int?;
                final joinDate = createdAt != null
                    ? DateFormat('MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(createdAt))
                    : l10n.nA;
                
                profile = CustomerProfileModel(
                  name: profileData['full_name'] as String? ?? '',
                  email: profileData['email'] as String? ?? '',
                  phone: profileData['phone_number'] as String? ?? '',
                  profileImagePath: profileData['profile_image_path'] as String? ?? 'lib/assets/PFP.png',
                  userType: l10n.regularCustomer,
                  totalOrders: profileData['total_orders'] as int? ?? 0,
                  joinDate: joinDate,
                );
              }
              
              if (profile == null) {
                return Scaffold(
                  backgroundColor: Colors.grey[200],
                  body: Center(child: Text(l10n.noProfileDataAvailable)),
                );
              }
              
              return Scaffold(
                backgroundColor: Colors.grey[200],
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36.0,
                        vertical: 30.0,
                      ),
                      child: Column(
                        children: [
                          // header
                          Logo(),

                          ProfileHeader(
                            profile: profile,
                            onEditProfile: () {
                              print('🔵 Edit Profile button clicked');
                              try {
                                final profileCubit = context.read<CustomerProfileCubit>();
                                final profileState = profileCubit.state;
                                print('🔵 Profile state: ${profileState.runtimeType}');
                                
                                if (profileState is CustomerProfileLoaded) {
                                  // Get the full response data, not just the nested profile
                                  // The backend returns: { 'profile': {...}, 'full_name': ..., etc }
                                  // But we stored only the nested 'profile' part in the state
                                  // We need to merge user data with profile data
                                  final profileData = Map<String, dynamic>.from(profileState.profile);
                                  
                                  // Add user-level fields that might be needed
                                  // These come from the user object, not the customer_profile
                                  print('🔵 Profile data keys: ${profileData.keys}');
                                  print('🔵 Calling EditProfileDialog.show()');
                                  
                                  EditProfileDialog.show(context, profileData);
                                  print('🔵 EditProfileDialog.show() called');
                                } else {
                                  print('⚠️ Profile not loaded yet. State: ${profileState.runtimeType}');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.profileNotLoadedYet),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              } catch (e, stackTrace) {
                                print('❌ Error in onEditProfile: $e');
                                print('❌ Stack trace: $stackTrace');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${l10n.error}: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 20),
                          // divider
                          Divider(color: primaryColor, thickness: 1),

                          SizedBox(height: 20),

                          // list of items
                          Column(
                            children: [
                              ServiceTile(
                                iconPath: 'lib/assets/orders.png',
                                title: l10n.myOrders,
                                description: l10n.viewOrderHistory,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyOrdersPage(customerId: customerId!),
                                    ),
                                  );
                                },
                              ),
                              ServiceTile(
                                iconPath: 'lib/assets/delivery.png',
                                title: l10n.deliveryAddress,
                                description: l10n.manageSavedLocations,
                                onTap: () {
                                  DeliveryAddressDialog.show(context);
                                },
                              ),
                              
                              // Language Selection
                              ServiceTile(
                                iconPath: 'lib/assets/delivery.png', // You can change this icon
                                title: l10n.selectLanguage,
                                description: l10n.chooseLanguage,
                                onTap: () => _showLanguageDialog(context, l10n),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  
  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.selectLanguage,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(
              context,
              flag: '🇬🇧',
              name: 'English',
              locale: const Locale('en'),
            ),
            const Divider(),
            _buildLanguageTile(
              context,
              flag: '🇩🇿',
              name: 'العربية',
              locale: const Locale('ar'),
            ),
            const Divider(),
            _buildLanguageTile(
              context,
              flag: '🇫🇷',
              name: 'Français',
              locale: const Locale('fr'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String flag,
    required String name,
    required Locale locale,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 28)),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        MyApp.setLocale(context, locale);
        Navigator.pop(context);
      },
    );
  }
}
