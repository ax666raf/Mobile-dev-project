import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/main.dart';
import 'package:mahsoul_dz/views/themes/colors.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/serviceTile.dart';
import 'package:mahsoul_dz/views/widgets/common/Logo.dart';
import 'package:mahsoul_dz/views/screens/customerSide/my_orders_page.dart';
import 'package:mahsoul_dz/views/screens/customerSide/delivery_address_dialog.dart';
import 'package:mahsoul_dz/logic/customer_profile_controller.dart';
import 'package:mahsoul_dz/views/models/customerSide/customer_profile_model.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller instance
  final CustomerProfileController _controller = CustomerProfileController();
  late CustomerProfileModel _profile;

  @override
  void initState() {
    super.initState();
    _profile = _controller.getCustomerProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
                  profile: _profile,
                  onEditProfile: _controller.editProfile,
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
                            builder: (context) => const MyOrdersPage(),
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
