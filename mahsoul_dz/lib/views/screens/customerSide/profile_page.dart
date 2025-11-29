import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/themes/colors.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/serviceTile.dart';
import 'package:mahsoul_dz/views/widgets/common/Logo.dart';
import 'package:mahsoul_dz/views/screens/customerSide/my_orders_page.dart';
import 'package:mahsoul_dz/views/screens/customerSide/delivery_address_dialog.dart';
import 'package:mahsoul_dz/logic/customer_profile_controller.dart';
import 'package:mahsoul_dz/views/models/customerSide/customer_profile_model.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/profile_header.dart';

/// Customer Profile Page - View Layer (MVC Pattern)
/// Displays customer profile information and menu options
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
                      title: 'My Orders',
                      description: 'view order history & track delivery',
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
                      title: 'Delivery address',
                      description: 'Manage saved delivery locations',
                      onTap: () {
                        DeliveryAddressDialog.show(context);
                      },
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
}
