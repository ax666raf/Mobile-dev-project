import 'package:flutter/material.dart';
import 'package:mahsoul_dz/data/models/farmerSide/farmer_profile_model.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

class ProfileCard extends StatelessWidget {
  final FarmerProfileModel profile;
  final VoidCallback onEditProfile;
  final VoidCallback? onEditImage;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
    this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          // Profile Image with Verification Badge and Edit Icon
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 3),
                  color: Colors.grey.shade200,
                ),
                child: ClipOval(
                  child: ImageStorageHelper.getImageWidget(
                    profile.profileImageUrl.isNotEmpty ? profile.profileImageUrl : 'lib/assets/farmerpfp.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (profile.isVerified)
                Positioned(
                  top: 0,
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
          const SizedBox(height: 16),
          
          // Farm Name
          Text(
            profile.farmName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          
          // Verified Farmer Badge
          if (profile.isVerified)
            Text(
              l10n.verifiedFarmer,
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
                onPressed: onEditProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.editProfile,
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
          _buildProfileInfo('${l10n.farmLocation}:', profile.farmLocation),
          const SizedBox(height: 12),
          _buildProfileInfo('${l10n.establishedYear}:', profile.established),
          const SizedBox(height: 12),
          _buildProfileInfo('${l10n.contactNumber}:', profile.contactNumber),
          const SizedBox(height: 12),
          _buildProfileInfo('${l10n.emailAddress}:', profile.emailAddress),
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
}
