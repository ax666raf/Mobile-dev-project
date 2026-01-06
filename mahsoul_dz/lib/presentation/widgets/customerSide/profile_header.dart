import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mahsoul_dz/data/models/customerSide/customer_profile_model.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

/// Profile Header Widget
/// Displays user profile picture, name, user type, and edit button
class ProfileHeader extends StatelessWidget {
  final CustomerProfileModel profile;
  final VoidCallback onEditProfile;
  final VoidCallback? onEditImage;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditProfile,
    this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // profile picture with edit icon
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: ClipOval(
                child: ImageStorageHelper.getImageWidget(
                  profile.profileImagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (onEditImage != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),

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
        MyButton(text: l10n.editProfile, onPressed: onEditProfile),
      ],
    );
  }
}
