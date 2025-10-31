import 'package:flutter/material.dart';
import 'package:mahsoul_dz/themes/colors.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/widgets/serviceTile.dart';
import 'package:mahsoul_dz/widgets/Logo.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // profile picture
                    Image.asset('lib/assets/PFP.png'),

                    // name
                    Text(
                      'Ali Morad',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // user mode
                    Text(
                      'Regular Customer',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    SizedBox(height: 20),

                    // edit profile button
                    MyButton(text: 'Edit Profile', onPressed: () {}),
                  ],
                ),

                SizedBox(height: 20),
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
                      onTap: () {},
                    ),
                    ServiceTile(
                      iconPath: 'lib/assets/saved.png',
                      title: 'Saved Farms',
                      description: 'Your favorite local farmers',
                      onTap: () {},
                    ),
                    ServiceTile(
                      iconPath: 'lib/assets/delivery.png',
                      title: 'Delivery address',
                      description: 'Manage saved delivery locations',
                      onTap: () {},
                    ),
                    ServiceTile(
                      iconPath: 'lib/assets/rewards.png',
                      title: 'Rewards & Points',
                      description: 'Loyalty program & earned rewards',
                      onTap: () {},
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
