import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:mahsoul_dz/presentation/widgets/farmerSide/logout_button.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';
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
                
                final imagePath = profileData['profile_image_path'] as String? ?? 'lib/assets/PFP.png';
                print('🖼️ Customer Profile Image Path: $imagePath');
                profile = CustomerProfileModel(
                  name: profileData['full_name'] as String? ?? '',
                  email: profileData['email'] as String? ?? '',
                  phone: profileData['phone_number'] as String? ?? '',
                  profileImagePath: imagePath,
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
                            onEditImage: () async {
                              // Show image picker dialog
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 85,
                              );
                              
                              if (image != null && mounted) {
                                try {
                                  // Upload image to server
                                  final imageFile = File(image.path);
                                  final serverPath = await ImageStorageHelper.uploadImageToServer(
                                    imageFile,
                                    type: 'profile',
                                  );
                                  
                                  if (serverPath != null && mounted) {
                                    // Update profile image
                                    await context.read<CustomerProfileCubit>().updateProfileImage(serverPath);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Profile image updated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to upload image: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            onEditProfile: () {
                              print('🔵 Edit Profile button clicked');
                              try {
                                final profileCubit = context.read<CustomerProfileCubit>();
                                final profileState = profileCubit.state;
                                print('🔵 Profile state: ${profileState.runtimeType}');
                                
                                if (profileState is CustomerProfileLoaded) {
                                  final profileData = Map<String, dynamic>.from(profileState.profile);
                                  
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
                          Divider(color: primaryColor, thickness: 1),

                          SizedBox(height: 20),

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
                                iconPath: 'lib/assets/delivery.png', 
                                title: l10n.selectLanguage,
                                description: l10n.chooseLanguage,
                                onTap: () => _showLanguageDialog(context, l10n),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Logout Button
                          LogoutButton(
                            onTap: () {
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
                                        context.read<AuthCubit>().logout();
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
