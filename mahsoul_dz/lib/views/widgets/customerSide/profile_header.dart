import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/models/customerSide/customer_profile_model.dart';
import 'package:mahsoul_dz/views/widgets/common/button.dart';

/// Profile Header Widget
/// Displays user profile picture, name, user type, and edit button
class ProfileHeader extends StatelessWidget {
  final CustomerProfileModel profile;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // profile picture
        Image.asset(profile.profileImagePath),

        // name
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // user mode
        Text(
          profile.userType,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),

        const SizedBox(height: 20),

        // edit profile button
        MyButton(text: 'Edit Profile', onPressed: onEditProfile),
      ],
    );
  }
}
